//
//  ProtractorDrawer.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 5/19/23.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import Foundation
import Protractor
import SwiftGodot
import SwiftGodotMacros

/// A node that allows drawing lines that can be matched with a list of recognized gestures.
///
/// When added to the scene tree, the `recognized` singal will be emitted whenever the user draws a line on the panel.
/// This signal returns the recognizer's best guess as a string, or an empty string if no match could be found.
///
/// The drawer can also be used to generate templates. By turning on ``debugPrintPaths`` in the editor, the path will be
/// printed out into the console, which can be added to a JSON file containing the templates.
@NativeHandleDiscarding
public class ProtractorDrawer: Node2D {
    /// The name for the `recognized` signal.
    public static var recognizedSignalName = StringName("recognized")
    var drawingArea: Area2D
    var visibleLine: Line2D

    var dragging: Bool = false
    var frame = Sprite2D()
    var recognizer = ProtractorRecognizer(accountForOrientation: true)

    /// Whether debugging statements should be displayed to show drawn paths. Defaults to false.
    ///
    /// This can be used as a means to capture user input to generate templates the drawer will be able to recognize.
    public var debugPrintPaths: Bool = false

    /// Whether the internal recognizer should account for orientation when recognizing templates. Defaults to false.
    public var orientationSensitive: Bool = false

    /// The path to a JSON resource in a Godot project that contains templates.
    ///
    /// This is passed to the recognizer internally to use as a source of truth for matching gestures.
    public var protractorTemplate: String = ""

    /// Generates an instance of the drawer node in the Godot scene.
    public required init() {
        ProtractorDrawer.initClass
        drawingArea = Area2D()
        visibleLine = Line2D()
        super.init()
        setupArea()
        setupLine()
        setupFrame()
    }

    func getDebugPrintPaths(args _: [Variant]) -> Variant? {
        Variant(debugPrintPaths)
    }

    func getRecognizerOrientationSensitivity(args _: [Variant]) -> Variant? {
        Variant(orientationSensitive)
    }

    func getRecognizerTemplates(args _: [Variant]) -> Variant? {
        Variant(stringLiteral: protractorTemplate)
    }

    func setDebugPrintPaths(args: [Variant]) -> Variant? {
        ClassInfo.withCheckedProperty(named: "debugPrintPaths", in: args) { arg in
            debugPrintPaths = Bool(arg) ?? false
        }
    }

    func setRecognizerOrientationSensitiviy(args: [Variant]) -> Variant? {
        ClassInfo.withCheckedProperty(named: "orientationSensitive", in: args) { arg in
            orientationSensitive = Bool(arg) ?? false
        }
    }

    func setRecognizerTemplate(args: [Variant]) -> Variant? {
        ClassInfo.withCheckedProperty(named: "templates", in: args) { arg in
            protractorTemplate = String(arg) ?? ""
            do {
                recognizer.dropTemplates()
                try recognizer.insertTemplates(reading: protractorTemplate)
                GD.print("Loaded templates:", recognizer.templates.map(\.name))
            } catch {
                GD.pushError("Failed to add template:", error.localizedDescription)
            }
        }
    }

    private func setupArea() {
        drawingArea.addChild(node: drawingBounds(of: .init(x: 256, y: 256)))
        drawingArea.inputPickable = true
        addChild(node: drawingArea)
        drawingArea.inputEvent.connect { _, event, _ in
            // TODO: Would be nice if I could conditional type cast here...
            // Register mouse events for clicking and dragging.
            if event.getClass() == "\(InputEventMouseButton.self)", !event.asText().starts(with: "Mouse Wheel") {
                self.startDrawing(with: event)
                return
            }

            if event.getClass() == "\(InputEventMouseMotion.self)", self.dragging {
                self.continueDrawing(with: event)
                return
            }

            // Register touch events for touchscreens/iOS.
            if event.getClass() == "\(InputEventScreenTouch.self)" {
                GD.print("Registering touch event for starting")
                self.startDrawing(with: event)
                return
            }

            if event.getClass() == "\(InputEventScreenDrag.self)" {
                GD.print("Registering touch event for drawing")
                self.continueDrawing(with: event)
                return
            }
        }
    }

    private func setupFrame() {
        guard let frameResource: Texture2D = GD.load(path: "res://resources/pb_border.png") else { return }
        frame.texture = #texture2DLiteral("res://resources/pb_border.png")
        frame.textureFilter = .nearest
        frame.zIndex = -1
        frame.scale = .init(x: 3, y: 3)
        addChild(node: frame)
    }

    private func setupLine() {
        addChild(node: visibleLine)
        visibleLine.antialiased = true
        visibleLine.endCapMode = .lineCapRound
        visibleLine.beginCapMode = .lineCapRound
        visibleLine.jointMode = .lineJointRound
    }

    private func drawingBounds(of size: Vector2) -> CollisionShape2D {
        let rectangle = RectangleShape2D()
        rectangle.size = size

        let collisionShape = CollisionShape2D()
        collisionShape.shape = rectangle

        return collisionShape
    }

    private func startDrawing(with event: InputEvent) {
        dragging = event.isPressed()
        if !event.isPressed() {
            endDrawing(from: event)
            return
        }
        if !visibleLine.points.isEmpty(), event.isPressed() {
            visibleLine.clearPoints()
        }
        visibleLine.addPoint(position: getLocalMousePosition())
    }

    private func continueDrawing(with _: InputEvent) {
        visibleLine.addPoint(position: getLocalMousePosition())
    }

    private func endDrawing(from _: InputEvent) {
        visibleLine.addPoint(position: getLocalMousePosition())
        let path = ProtractorPath(line: visibleLine)
        recognizer.setPath(path, orientationSensitive: orientationSensitive)

        if debugPrintPaths {
            let printedPoints = visibleLine.points.map { [Int($0.x), Int($0.y)] }
            GD.print("Drawn Path:", printedPoints)
        }

        guard !recognizer.templates.isEmpty else {
            GD.pushWarning("Recognizer templates are empty.")
            return
        }

        let (name, accuracy) = recognizer.recognize()
        GD.print("Best guess:", name, "with accuracy:", accuracy)
        emitSignal(Self.recognizedSignalName, Variant(stringLiteral: name))
    }
}
