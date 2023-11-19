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
public class JensonTimeline: Control {
    typealias TimelineState = JensonGodotTimelineState
    typealias AnimationName = JensonGodotAnimationName
    typealias ChildPath = JensonGodotChildPath
    typealias ImageRefreshPriorityLayer = JensonGodotImageRefreshPriorityLayer

    static var timelineFinishedSignalName = StringName("timeline_finished")

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

    @SceneTree(path: ChildPath.animationPlayer.rawValue) private var animator: AnimationPlayer?
    @SceneTree(path: ChildPath.background.rawValue) private var backgroundLayer: TextureRect?
    @SceneTree(path: ChildPath.choiceMenu.rawValue) private var menu: VBoxContainer?
    @SceneTree(path: ChildPath.leftSpeaker.rawValue) private var speakerLeft: TextureRect?
    @SceneTree(path: ChildPath.rightSpeaker.rawValue) private var speakerRight: TextureRect?
    @SceneTree(path: ChildPath.singleSpeaker.rawValue) private var speakerSingle: TextureRect?

    private var choices = [String: [JensonEvent]]()
    private var choiceTemplate: Button?
    private var currentEvent: JensonEvent?
    private var reader: JensonReader?
    private var timeline = [JensonEvent]()
    private var whoLabel: Label?
    private var whatLabel: Label?
    private var state = TimelineState.initial

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
        state = .started
        animator?.play(name: AnimationName.startTimeline.stringName)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.state = .playing
            self?.next()
        }
    }

    override public func _input(event: InputEvent) {
        super._input(event: event)
        if !visible { return }
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
        if state == .started { return }
        if animator.isPlaying(), animator.currentAnimation != AnimationName.startTimeline.rawValue {
            skipAnimation()
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
            state = .loaded
        } catch {
            GD.pushError("Failed to load reader for script", error.localizedDescription)
        }
    }

    func next() {
        guard !timeline.isEmpty else {
            if state != .ended {
                state = .ended
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
            state = .ended
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
    }

    func refreshScene(using triggers: [JensonRefreshContent]) {
        for trigger in triggers {
            switch trigger.kind {
            case .image:
                refreshImageLayer(with: trigger)
            default:
                GD.pushWarning("Unsupported refresh kind: \(trigger.kind.rawValue). This trigger will be skipped.")
            }
        }
        guard !TimelineState.unsafeRefreshStates.contains(state) else { return }
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

            // TODO: Perhaps we can be smarter about this in the future, so we know WHEN to flip this instead of just
            // flipping it all the time...
            speakerLeft?.flipH = true
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
        for choice in question.options {
            choices[choice.name] = choice.events
        }
        for child in menu.getChildren() where child != choiceTemplate {
            menu.removeChild(node: child)
        }
        for choiceName in question.options.map(\.name) {
            if let newButton = choiceTemplate?.duplicate() as? Button {
                setupButton(newButton, with: choiceName)
            }
        }
        menu.visible = true
    }

    func skipAnimation() {
        guard let animator else { return }
        animator.stop()

        for label in [whoLabel, whatLabel] {
            label?.visibleRatio = 1
        }

        for layer in [backgroundLayer, speakerSingle, speakerLeft, speakerRight] {
            layer?.modulate = Color.white
        }
    }

    private func setupButton(_ newButton: Button, with choiceName: String) {
        guard let menu else { return }
        newButton.text = choiceName
        newButton.visible = true
        _ = try? newButton.pressed.connect { [weak self] in
            self?.menu?.visible = false
            guard let events = self?.choices[choiceName] else {
                GD.pushWarning("No option with key '\(choiceName)' exists. No new events will be inserted.")
                return
            }
            self?.timeline.insert(contentsOf: events, at: 0)
            self?.next()
        }
        menu.addChild(node: newButton)
    }
}
