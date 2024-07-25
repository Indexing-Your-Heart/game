#region Copyright
//
//  JensonTimeline.cs
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 21/7/2024.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.
#endregion

using System.Collections.Generic;
using System.Linq;
using Godot;
using IndexingYourHeart.Utils;
using Jenson.NET;
using Jenson.NET.Models;

namespace IndexingYourHeart.UI
{
    /// <summary>
    /// A node that can display a Jenson script for dialogue or other story-based elements.
    /// </summary>
    public partial class JensonTimeline : Control
    {
        /// <summary>
        ///  A representation of the various states the current timeline can be in.
        /// </summary>
        public enum TimelineState
        {
            /// <summary>
            /// The initial state, where the node has been created, but the script hasn't been loaded yet.
            /// </summary>
            Initial,

            /// <summary>
            /// The script has been loaded, but the timeline hasn't started execution yet.
            /// </summary>
            Loaded,

            /// <summary>
            /// The script has been loaded and the timeline has started execution. This state is typically also used to
            /// indicate that the starting animation is playing, and any interactions should be ignored.
            /// </summary>
            Started,

            /// <summary>
            /// The script has been loaded and the timeline is actively playing events.
            /// </summary>
            Playing,

            /// <summary>
            /// The timeline has finished execution, and there are no more timeline events to read.
            /// </summary>
            Ended
        }

        public enum ImageRefreshPriorityLayer
        {
            Background = -1,
            SpeakerSingle = 0,
            SpeakerLeft = 1,
            SpeakerRight = 2
        }

        private static TimelineState[] UnsafeRefreshStates => [TimelineState.Initial, TimelineState.Loaded, TimelineState.Ended];

        /// <summary>
        /// The path to the timeline script to load. Ideally set in the editor, but can be manually instantiated.
        /// </summary>
        [Export(PropertyHint.File, "*.jenson")]
        public string Script = "";

        /// <summary>
        /// The current state of the timeline.
        /// </summary>
        public TimelineState CurrentTimelineState => _timelineState;

        private Dictionary<string, List<IJensonEvent>> choices = new();
        private Button choiceTemplate;
        private IJensonEvent currentEvent;
        private JensonReader reader;
        private List<IJensonEvent> timeline;
        private TimelineState _timelineState = TimelineState.Initial;

        #region Children Nodes
        private AnimationPlayer animator;
        private TextureRect backgroundLayer;
        private VBoxContainer menu;
        private TextureRect speakerLeft;
        private TextureRect speakerRight;
        private TextureRect speakerSingle;
        private Label whoLabel;
        private Label whatLabel;
        #endregion

        public override void _Ready()
        {
            animator = GetNode<AnimationPlayer>("AnimationPlayer");
            backgroundLayer = GetNode<TextureRect>("Background");
            menu = GetNode<VBoxContainer>("Choice Menu");
            speakerLeft = GetNode<TextureRect>("Multi Speakers/Left Speaker");
            speakerRight = GetNode<TextureRect>("Multi Speakers/Right Speaker");
            speakerSingle = GetNode<TextureRect>("Single Speaker");

            whoLabel = (Label)FindChild("Who Label", true);
            whatLabel = (Label)FindChild("What Label", true);

            choiceTemplate = menu.GetChild<Button>(0);

            menu.Visible = false;
            choiceTemplate.Visible = false;
            whoLabel.Text = "";
            whatLabel.Text = "";

            // Listen for when the animation finishes rather than using a dispatch queue.
            animator.AnimationFinished += delegate
            {
                if (_timelineState == TimelineState.Started)
                {
                    _timelineState = TimelineState.Playing;
                    Next();
                }
            };

            LoadScript();

            if (timeline.First().EventType == JensonEventType.Refresh)
                Next();

            _timelineState = TimelineState.Started;
            animator.Play("start_timeline");
        }

        public override void _Input(InputEvent @event)
        {
            if (!Visible)
                return;
            if (Input.IsActionPressed("timeline_next") || Input.IsMouseButtonPressed(MouseButton.Left))
                HandleNextEvent();
            base._Input(@event);
        }

        /// <summary>
        /// Loads the current script into the timeline node.
        /// </summary>
        public void LoadScript()
        {
            using var file = FileAccess.Open(Script, FileAccess.ModeFlags.Read);
            reader = new JensonReader(file.GetAsText());
            timeline = reader.Parse().timeline.ToList();
            _timelineState = TimelineState.Loaded;
            EmitSignal(SignalName.TimelineLoaded);
        }

        private void HandleNextEvent()
        {
            if (animator == null || menu.Visible || _timelineState == TimelineState.Started)
                return;
            if (animator.IsPlaying() && animator.CurrentAnimation != "start_timeline")
            {
                SkipAnimation();
                return;
            }
            Next();
        }

        private void Next()
        {
            if (timeline.Count == 0)
            {
                HandleEmptyTimeline();
                return;
            }
            currentEvent = timeline.RemoveFirst();
            SetupWithCurrentEvent();
        }

        private void HandleEmptyTimeline()
        {
            if (_timelineState != TimelineState.Ended)
            {
                _timelineState = TimelineState.Ended;
                GD.Print("Timeline has finished.");
                EmitSignal(SignalName.TimelineFinished);
                return;
            }
            GD.PushWarning("Attempted to move to an empty slot.");
        }

        private void RefreshSceneWithCurrentEvent()
        {
            RefreshEvent refreshEvent = (RefreshEvent)currentEvent;
            switch (refreshEvent.Kind)
            {
                case "image":
                    RefreshImageWithCurrentEvent();
                    break;
                default:
                    GD.PushWarning($"Unsupported refresh kind: {refreshEvent.Kind}. This trigger will be skipped.");
                    break;
            }
            if (UnsafeRefreshStates.Contains(_timelineState))
                return;
            Next();
        }

        private void RefreshImageWithCurrentEvent()
        {
            RefreshEvent refreshEvent = (RefreshEvent)currentEvent;
            switch (refreshEvent.Priority)
            {
                case (int)ImageRefreshPriorityLayer.Background:
                    string bgPath = $"res://resources/backgrounds/{refreshEvent.What}.png";
                    Texture2D backgroundTexture = GD.Load<Texture2D>(bgPath);
                    backgroundLayer.Texture = backgroundTexture;
                    break;
                case (int)ImageRefreshPriorityLayer.SpeakerSingle:
                    string speakSinglePath = $"res://resources/characters/{refreshEvent.What}.png";
                    Texture2D singleSpeakerTexture = GD.Load <Texture2D>(speakSinglePath);
                    speakerSingle.Texture = singleSpeakerTexture;
                    break;
                case (int)ImageRefreshPriorityLayer.SpeakerLeft:
                    string speakerLeftPath = $"res://resources/characters/{refreshEvent.What}.png";
                    Texture2D speakerLeftTexture = GD.Load<Texture2D>(speakerLeftPath);
                    speakerSingle.Texture = speakerLeftTexture;
                    speakerLeft.FlipH = true;
                    break;
                case (int)ImageRefreshPriorityLayer.SpeakerRight:
                    string speakerRightPath = $"res://resources/characters/{refreshEvent.What}.png";
                    Texture2D speakerRightTexture = GD.Load<Texture2D>(speakerRightPath);
                    speakerRight.Texture = speakerRightTexture;
                    break;
                default:
                    GD.PushWarning($"Unrecognized priority: {refreshEvent.Priority}. Skipping.");
                    break;
            }
        }

        private void SetupButton(Button button, string choiceName)
        {
            button.Text = choiceName.ToUpper();
            button.Visible = true;
            button.Pressed += delegate
            {
                menu.Visible = false;
                if (!choices.ContainsKey(choiceName))
                    return;
                var events = choices[choiceName];
                var mergedTimeline = events;
                foreach (var timelineEvent in timeline)
                {
                    mergedTimeline.Add(timelineEvent);
                }
                timeline = mergedTimeline;
                Next();
            };

            menu.AddChild(button);
        }

        private void SetupWithCurrentEvent()
        {
            animator.Stop();
            switch (currentEvent.EventType)
            {
                case JensonEventType.Narration:
                    SetupNarration();
                    break;
                case JensonEventType.Dialogue:
                    SetupDialogueWithCurrentEvent();
                    break;
                case JensonEventType.Refresh:
                    RefreshSceneWithCurrentEvent();
                    break;
                case JensonEventType.Question:
                    QuestionEvent question = (QuestionEvent)currentEvent;
                    DialogueEvent questionDialogue = new DialogueEvent(question.Who, question.What);
                    SetupDialogue(questionDialogue);
                    SetupQuestion();
                    break;
                default:
                    GD.PushWarning($"Unknown event type: {currentEvent.EventType}. Skipping.");
                    Next();
                    break;
            }
        }

        private void SetupDialogue(DialogueEvent dialogue)
        {
            whoLabel.Text = dialogue.Who;
            whatLabel.Text = dialogue.What;
            SkipImageModulation();
            animator.Play("speech", (double)dialogue.What.Length / 4);
        }

        private void SetupDialogueWithCurrentEvent()
        {
            DialogueEvent dialogue = (DialogueEvent)currentEvent;
            whoLabel.Text = dialogue.Who;
            whatLabel.Text = dialogue.What;
            SkipImageModulation();
            animator.Play("speech", (double)dialogue.What.Length / 4);
            EmitSignal(SignalName.TimelineDialogueFired, whoLabel.Text, whatLabel.Text);
        }

        private void SetupNarration()
        {
            NarrationEvent narration = (NarrationEvent)currentEvent;
            whatLabel.Text = narration.What;
            whoLabel.Text = "";
            SkipImageModulation();
            animator.Play("speech", (double)narration.What.Length / 4);
            EmitSignal(SignalName.TimelineDialogueFired, "<#narration#>", whatLabel.Text);
        }

        private void SetupQuestion()
        {
            QuestionEvent question = (QuestionEvent)currentEvent;
            choices.Clear();
            foreach (var choice in question.Choices)
            {
                choices[choice.What] = choice.Events.ToList();
            }

            foreach (var child in menu.GetChildren().Where((child) => child != choiceTemplate))
            {
                menu.RemoveChild(child);
            }

            foreach (var choiceName in question.Choices.Select((choice) => choice.What))
            {
                Button newButton = (Button)choiceTemplate.Duplicate();
                SetupButton(newButton, choiceName);
            }

            menu.Visible = true;
        }

        private void SkipAnimation()
        {
            animator.Stop();
            whoLabel.VisibleRatio = 1;
            whatLabel.VisibleRatio = 1;

            SkipImageModulation();
        }

        private void SkipImageModulation()
        {
            backgroundLayer.Modulate = Colors.White;
            speakerLeft.Modulate = Colors.White;
            speakerRight.Modulate = Colors.White;
            speakerSingle.Modulate = Colors.White;
        }

        [Signal]
        public delegate void TimelineLoadedEventHandler();

        [Signal]
        public delegate void TimelineDialogueFiredEventHandler(string Who, string What);

        [Signal]
        public delegate void TimelineFinishedEventHandler();
    }
}
