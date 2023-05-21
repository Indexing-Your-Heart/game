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
import SwiftGodot
import GDExtension

class ProtractorDrawer: Node2D {
    var drawingArea: Area2D
    var visibleLine: Line2D

    private var dragging: Bool = false
    private var frame = Sprite2D()
    private var recognizer = ProtractorRecognizer(accountForOrientation: true)

    private var debugPrintPaths: Bool
    private var orientationSensitive: Bool
    private var protractorTemplate: String

    required init() {
        ProtractorDrawer.initClass
        self.drawingArea = Area2D()
        self.visibleLine = Line2D()
        self.orientationSensitive = false
        self.protractorTemplate = ""
        self.debugPrintPaths = false
        super.init()
        self.setupArea()
        self.setupLine()
        self.setupFrame()
        self.setupRecognizer()
    }

    required init(nativeHandle: UnsafeRawPointer) {
        fatalError("init(nativeHandle:) not implemented")
    }

    func getDebugPrintPaths(args: [Variant]) -> Variant? {
        return(Variant(debugPrintPaths))
    }

    func getRecognizerOrientationSensitivity(args: [Variant]) -> Variant? {
        return Variant(orientationSensitive)
    }

    func getRecognizerTemplates(args: [Variant]) -> Variant? {
        return Variant(stringLiteral: protractorTemplate)
    }

    func setDebugPrintPaths(args: [Variant]) -> Variant? {
        guard let arg = args.first else {
            GD.pushError("Expected argument for orientation sensitivity, but got nil")
            return nil
        }
        self.debugPrintPaths = Bool(arg) ?? false
        return nil
    }

    func setRecognizerOrientationSensitiviy(args: [Variant]) -> Variant? {
        guard let arg = args.first else {
            GD.pushError("Expected argument for orientation sensitivity, but got nil")
            return nil
        }
        self.orientationSensitive = Bool(arg) ?? false
        return nil
    }

    func setRecognizerTemplate(args: [Variant]) -> Variant? {
        guard let arg = args.first else {
            GD.pushError("Expected argument of file path, but got nil.")
            return nil
        }
        self.protractorTemplate = String(arg) ?? ""
        GD.print("Got template string", self.protractorTemplate)
        do {
            self.recognizer.dropTemplates()
            try self.recognizer.insertTemplates(reading: self.protractorTemplate)
            GD.print(self.recognizer.templates.map(\.name))
        } catch {
            GD.pushError("Failed to add template:", error.localizedDescription)
        }
        return nil
    }

    private func setupArea() {
        self.drawingArea.addChild(node: drawingBounds(of: .init(x: 256, y: 256)))
        self.drawingArea.inputPickable = true
        self.addChild(node: drawingArea)
        self.drawingArea.inputEvent.connect { viewport, event, shapeIdx in
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
        self.frame.texture = frameResource
        self.frame.textureFilter = .nearest
        self.frame.zIndex = -1
        self.frame.scale = .init(x: 3, y: 3)
        self.addChild(node: frame)
    }

    private func setupLine() {
        self.addChild(node: visibleLine)
        //        self.visibleLine.defaultColor = Color(code: "#102030", alpha: 1.0)
        self.visibleLine.antialiased = true
        self.visibleLine.endCapMode = .lineCapRound
        self.visibleLine.beginCapMode = .lineCapRound
        self.visibleLine.jointMode = .lineJointRound
    }

    private func setupRecognizer() {
        // TODO: Can we use an exported variable to have a list of resources to load from instead?
        do {
            try self.recognizer.insertTemplates(reading: "res://data/templates.json")
//            try self.recognizer.insertTemplates(reading: "res://data/Ashashat.json")
        } catch {
            GD.pushError("Failed to load templates", error.localizedDescription)
        }
    }

    private func drawingBounds(of size: Vector2) -> CollisionShape2D {
        let rectangle = RectangleShape2D()
        rectangle.size = size

        let collisionShape = CollisionShape2D()
        collisionShape.shape = rectangle

        return collisionShape
    }

    private func startDrawing(with event: InputEvent) {
        self.dragging = event.isPressed()
        if !event.isPressed() {
            self.endDrawing(from: event)
            return
        }
        if !self.visibleLine.points.isEmpty(), event.isPressed() {
            self.visibleLine.clearPoints()
        }
        self.visibleLine.addPoint(position: getLocalMousePosition())
    }

    private func continueDrawing(with event: InputEvent) {
        self.visibleLine.addPoint(position: getLocalMousePosition())
    }

    private func endDrawing(from event: InputEvent) {
        self.visibleLine.addPoint(position: getLocalMousePosition())
        let path = ProtractorPath(line: self.visibleLine)
        self.recognizer.setPath(path, orientationSensitive: orientationSensitive)

        if debugPrintPaths {
            let printedPoints = self.visibleLine.points.map { [Int($0.x), Int($0.y)] }
            GD.print("Drawn Path:", printedPoints)
        }

        guard !self.recognizer.templates.isEmpty else {
            GD.pushWarning("Recognizer templates are empty.")
            return
        }

        let (name, accuracy) = recognizer.recognize()
        GD.print("Best guess:", name, "Accuracy:", accuracy, separator: "\t")
    }
}
