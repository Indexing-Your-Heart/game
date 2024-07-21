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
using Jenson.NET;
using Jenson.NET.Models;

namespace IndexingYourHeart.UI
{
    public partial class JensonTimeline : Control
    {
        private enum TimelineState
        {
            Initial,
            Loaded,
            Started,
            Playing,
            Ended
        }

        private enum ImageRefreshPriorityLayer
        {
            Background = -1,
            SpeakerSingle = 0,
            SpeakerLeft = 1,
            SpeakerRight = 2
        }

        private static TimelineState[] UnsafeRefreshStates => [TimelineState.Initial, TimelineState.Loaded, TimelineState.Ended];

        [Export(PropertyHint.File, "*.jenson")]
        public string Script = "";

        private Dictionary<string, IJensonEvent> choices = new();
        private Button choiceTemplate;
        private IJensonEvent currentEvent;
        private JensonReader reader;
        private List<IJensonEvent> timeline;
        private TimelineState timelineState = TimelineState.Initial;

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

        // Called when the node enters the scene tree for the first time.
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

            animator.AnimationFinished += delegate
            {
                if (timelineState == TimelineState.Started)
                {
                    timelineState = TimelineState.Playing;
                    Next();
                }
            };

            CreateReaderFromScript();

            if (timeline.First().EventType == JensonEventType.Refresh)
                Next();

            timelineState = TimelineState.Started;
            animator.Play("start_timeline");
        }

        public override void _Input(InputEvent @event)
        {
            base._Input(@event);
            if (!Visible)
                return;
            if (Input.IsActionPressed("timeline_next") || Input.IsMouseButtonPressed(MouseButton.Left))
                HandleNextEvent();
        }

        private void CreateReaderFromScript()
        {
            using var file = FileAccess.Open(Script, FileAccess.ModeFlags.Read);
            reader = new JensonReader(file.GetAsText());
            timeline = reader.Parse().timeline.ToList();
            timelineState = TimelineState.Loaded;
        }

        private void HandleNextEvent()
        {
            if (animator == null || menu.Visible || timelineState == TimelineState.Started)
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
                if (timelineState != TimelineState.Ended)
                {
                    timelineState = TimelineState.Ended;
                    GD.Print("Timeline has finished.");
                    EmitSignal(SignalName.TimelineFinished);
                    return;
                }
                GD.PushWarning("Attempted to move to an empty slot.");
                return;
            }
            currentEvent = timeline[0];
            timeline.RemoveAt(0);
            SetupWithCurrentEvent();
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
            if (UnsafeRefreshStates.Contains(timelineState))
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

        private void SetupWithCurrentEvent()
        {
            animator.Stop();
            switch (currentEvent.EventType)
            {
                case JensonEventType.Narration:
                    SetupNarration();
                    break;
                case JensonEventType.Dialogue:
                    SetupDialogue();
                    break;
                case JensonEventType.Refresh:
                    RefreshSceneWithCurrentEvent();
                    break;
                default:
                    GD.PushWarning($"Unknown event type: {currentEvent.EventType}. Skipping.");
                    Next();
                    break;
            }
        }

        private void SetupDialogue()
        {
            DialogueEvent dialogue = (DialogueEvent)currentEvent;
            whoLabel.Text = dialogue.Who;
            whatLabel.Text = dialogue.What;
            SkipImageModulation();
            animator.Play("speech", (double)dialogue.What.Length / 4);
        }

        private void SetupNarration()
        {
            NarrationEvent narration = (NarrationEvent)currentEvent;
            whatLabel.Text = narration.What;
            whoLabel.Text = "";
            SkipImageModulation();
            animator.Play("speech", (double)narration.What.Length / 4);
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
        public delegate void TimelineFinishedEventHandler();
    }
}
