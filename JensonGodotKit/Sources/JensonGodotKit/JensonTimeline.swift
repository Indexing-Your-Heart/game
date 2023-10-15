//
//  JensonTimeline.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 5/30/23.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import JensonKit
import SwiftGodot

/// A Godot node that registers a Jenson timeline and attempts to update any children UI elements to reflect the current
/// event in the story.
@NativeHandleDiscarding
public class JensonTimeline: Node {
    static var timelineFinishedSignalName = StringName("timeline_finished")

    enum AnimationName: String {
        case startTimeline = "start_timeline"
        case speech

        var stringName: StringName {
            StringName(stringLiteral: rawValue)
        }
    }

    enum ChildPath: String {
        case animationPlayer = "AnimationPlayer"
        case background = "Background"
        case choiceMenu = "Choice Menu"
        case leftSpeaker = "Left Speaker"
        case rightSpeaker = "Right Speaker"
        case singleSpeaker = "Single Speaker"
    }

    enum ImageRefreshPriorityLayer: Int {
        case background = -1
        case speakerSingle = 0
        case speakerLeft = 1
        case speakerRight = 2
        case unknown = -999
    }

    /// Whether comment events should be displayed.
    @Autovariant public var displayCommentary: Bool = false

    /// The script being loaded into the timeline.
    @Autovariant public var script: String = "" {
        didSet {
            if !Engine.isEditorHint() {
                loadScript()
            }
        }
    }

    @SceneTree(path: ChildPath.animationPlayer.rawValue)
    private var animator: AnimationPlayer?

    @SceneTree(path: ChildPath.background.rawValue)
    private var backgroundLayer: TextureRect?
    private var choices = [String: [JensonEvent]]()
    private var choiceTemplate: Button?
    private var currentEvent: JensonEvent?
    private var finished = false
    private var initialized = false

    @SceneTree(path: ChildPath.choiceMenu.rawValue)
    private var menu: VBoxContainer?

    private var reader: JensonReader?

    @SceneTree(path: ChildPath.leftSpeaker.rawValue)
    private var speakerLeft: TextureRect?

    @SceneTree(path: ChildPath.rightSpeaker.rawValue)
    private var speakerRight: TextureRect?

    @SceneTree(path: ChildPath.singleSpeaker.rawValue)
    private var speakerSingle: TextureRect?
    private var timeline = [JensonEvent]()
    private var whoLabel: Label?
    private var whatLabel: Label?

    public required init() {
        JensonTimeline.initializeClass()
        super.init()
    }

    override public func _ready() {
        super._ready()
        whoLabel = findChild(pattern: "Who Label", recursive: true) as? Label
        whatLabel = findChild(pattern: "What Label", recursive: true) as? Label

        choiceTemplate = menu?.getChild(idx: 0) as? Button

        guard !Engine.isEditorHint() else { return }
        menu?.visible = false
        choiceTemplate?.visible = false
        whoLabel?.text = ""
        whatLabel?.text = ""

        if !displayCommentary {
            GD.print("Removing developer commentary nodes.")
            timeline.removeAll { event in
                event.type == .comment
            }
        }

        preloadRefreshedData()
        animator?.play(name: AnimationName.startTimeline.stringName)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.initialized = true
            self?.next()
        }
    }

    override public func _input(event _: InputEvent) {
        if Input.isActionPressed(action: .timelineNext) || Input.isMouseButtonPressed(button: .left) {
            handleNextEvent()
        }
    }

    func handleNextEvent() {
        guard let animator else {
            next()
            return
        }
        if let menu, menu.visible { return }
        if animator.isPlaying(), animator.currentAnimation != AnimationName.startTimeline.rawValue, let whatLabel {
            animator.stop()
            whatLabel.visibleRatio = 1
            return
        }
        next()
    }

    func loadScript() {
        do {
            let reader = try JensonReader(resource: script)
            guard let file = try reader?.decode() else {
                GD.pushError("Decoded file for \(String(describing: script)) returned nil.")
                return
            }
            timeline = file.timeline
            if timeline.isEmpty {
                GD.pushWarning("The file loaded, but the timeline is empty.")
                return
            }
        } catch {
            GD.pushError("Failed to load reader for script", error.localizedDescription)
        }
    }

    func next() {
        guard !timeline.isEmpty else {
            if !finished {
                finished.toggle()
                GD.print("Timeline has finished.")
                try? emitSignal(JensonTimeline.timelineFinishedSignalName)
            }
            GD.pushWarning("Attempted to move to an empty slot.")
            return
        }
        currentEvent = timeline.removeFirst()
        if let currentEvent {
            setup(event: currentEvent)
        } else {
            GD.print("Timeline has completed.")
            try? emitSignal(JensonTimeline.timelineFinishedSignalName)
        }
    }

    func preloadRefreshedData() {
        guard !Engine.isEditorHint(), let first = timeline.first else { return }
        if first.type != .refresh {
            GD.pushWarning("Next event doesn't require initial setup.")
            return
        }
        GD.print("Running initial refresh contents.")
        next()
        initialized = true
    }

    func refreshScene(using triggers: [JensonRefreshContent]) {
        triggers.forEach { trig in
            switch trig.kind {
            case .image:
                refreshImageLayer(with: trig)
            default:
                GD.pushWarning("Unsupported refresh kind: \(trig.kind.rawValue). This trigger will be skipped.")
            }
        }
        guard initialized else { return }
        next()
    }

    func refreshImageLayer(with trigger: JensonRefreshContent) {
        guard let priority = ImageRefreshPriorityLayer(rawValue: trigger.priority ?? -999) else {
            GD.pushWarning("Skipping priority-less image trigger.")
            return
        }
        switch priority {
        case .background:
            guard let tex: Texture2D = GD.load(path: "res://resources/backgrounds/\(trigger.resourceName).png") else {
                GD.pushWarning("Unable to find image resource \(trigger.resourceName).")
                return
            }
            backgroundLayer?.texture = tex
        case .speakerSingle:
            guard let tex: Texture2D = GD.load(path: "res://resources/characters/\(trigger.resourceName).png") else {
                GD.pushWarning("Unable to find image resource \(trigger.resourceName).")
                return
            }
            speakerSingle?.texture = tex
        case .speakerLeft:
            guard let tex: Texture2D = GD.load(path: "res://resources/characters/\(trigger.resourceName).png") else {
                GD.pushWarning("Unable to find image resource \(trigger.resourceName).")
                return
            }
            speakerLeft?.texture = tex
        case .speakerRight:
            guard let tex: Texture2D = GD.load(path: "res://resources/characters/\(trigger.resourceName).png") else {
                GD.pushWarning("Unable to find image resource \(trigger.resourceName).")
                return
            }
            speakerRight?.texture = tex
        case .unknown:
            GD.pushWarning("Skipping refresh with unknown priority.")
        }
    }

    func setup(event: JensonEvent) {
        switch event.type {
        case .dialogue:
            setupDialogue(with: event)
        case .question:
            setupDialogue(with: event)
            guard let question = event.question else {
                GD.pushWarning("Question event expected a question object, but received nil.")
                return
            }
            setupQuestion(question: question)
        case .refresh:
            if let refreshTriggers = event.refresh {
                refreshScene(using: refreshTriggers)
            }
        case .comment where displayCommentary:
            setupDialogue(with: event, overrideSpeaker: "Developer Commentary")
        default:
            GD.pushWarning("Unknown event type: \(event.type.rawValue). This will be skipped.")
            next()
        }
    }

    func setupDialogue(with event: JensonEvent, overrideSpeaker speaker: String? = nil) {
        whoLabel?.text = speaker ?? event.who
        whatLabel?.text = event.what
        animator?.play(name: AnimationName.speech.stringName, customSpeed: Double(event.what.count) / 4.0)
    }

    func setupQuestion(question: JensonQuestion) {
        guard let menu else { return }
        choices.removeAll()
        question.options.forEach { choice in
            choices[choice.name] = choice.events
        }
        menu.getChildren()
            .filter { child in child != choiceTemplate }
            .forEach(menu.removeChild(node:))
        question.options.map(\.name).forEach { choiceName in
            if let newButton = choiceTemplate?.duplicate() as? Button {
                newButton.text = choiceName
                _ = try? newButton.pressed.connect { [weak self] in
                    self?.menu?.visible = false
                    guard let events = self?.choices[choiceName] else {
                        GD.pushWarning("No option with key '\(choiceName)' exists. No new events will be inserted.")
                        return
                    }
                    self?.timeline.insert(contentsOf: events, at: 0)
                    self?.next()
                }
                newButton.visible = true
                menu.addChild(node: newButton)
            }
        }
        menu.visible = true
    }
}
