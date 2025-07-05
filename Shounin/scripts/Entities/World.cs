#region Copyright
// World.cs
// Indexing Your Heart
// 
// Created by Marquis Kurt on 04/11/2024.
// 
// This file is part of Indexing Your Heart.
// 
// Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
// CNPLv7+ as found in the LICENSE file in the source code root directory or at
// <https://git.pixie.town/thufie/npl-builder>.
// 
// Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
// details.
#endregion

using Godot;
using IndexingYourHeart.UI;
using IndexingYourHeart.Utils;
using IndexingYourHeart.Utils.Animation;
using System.Collections.Generic;

namespace IndexingYourHeart.Entities;

public partial class World : Node2D
{
    private AnthroPlayer _player;
    private Control _scriptOverlay;
    private Control _tutorialMovementNode;
    private Control _tutorialInteractNode;
    private JensonTimeline _timelineNode;

    private const double _tutorialInteractFadeTime = 0.25;
    private bool _birthTripwire = false;

    public override void _Ready()
    {
        base._Ready();
        _player = GetNode<AnthroPlayer>("Player");
        _scriptOverlay = GetNode<Control>("CanvasLayer/Overlay");
        _tutorialMovementNode = GetNode<Control>("CanvasLayer/TutorialMovement");
        _tutorialInteractNode = GetNode<Control>("CanvasLayer/TutorialInteract");
        _timelineNode = GetNode<JensonTimeline>("CanvasLayer/Timeline");

        _tutorialInteractNode.Modulate = Colors.Transparent;

        _timelineNode.TimelineFinished += () =>
        {
            string timeline = _timelineNode.Script.Replace("res://data/", "").Replace(".jenson", "");
            RollinsportMessageBus.Instance.SendMessage(RollinsportMessageBus.TimelineMessage.WatchedTimeline, timeline);

            this.Animate(UIAnimation.LinearEaseInOut(), new UIAnimationProperty
            {
                Target = _timelineNode,
                Property = "modulate",
                EndState = Colors.Transparent
            }, () =>
            {
                _timelineNode.Visible = false;
                GetTree().Paused = false;
            });

            GetTree().Paused = false;
            this.Animate(UIAnimation.LinearEaseInOut(), new UIAnimationProperty
            {
                Target = _scriptOverlay,
                Property = "modulate",
                EndState = Colors.Transparent
            }, () =>
            {
                // Show movement tutorial when the player is just starting, after the beginning scene plays.
                if (_birthTripwire)
                    _tutorialMovementNode.Visible = true;
            });
        };

        // Initiate the preamble when the player is born.
        RollinsportMessageBus.Instance.PlayerGivenBirth += () =>
        {
            _birthTripwire = true;
            _timelineNode.Script = "res://data/preamble_v3.jenson";
            _timelineNode.LoadScript();
        };

        // Load timelines when requested. Notably, whenever a player walks into a trigger that fires this event.
        RollinsportMessageBus.Instance.TimelineRequestTimeline += (timeline) =>
        {
            _timelineNode.Script = timeline;
            _timelineNode.LoadScript();
        };

        // Start the timeline after the script is loaded in.
        _timelineNode.TimelineLoaded += () =>
        {
            List<UIAnimationProperty> propertiesToAnimate =
            [
                new UIAnimationProperty
                {
                    Target = _scriptOverlay,
                    Property = "modulate",
                    EndState = Colors.White
                },
                new UIAnimationProperty
                {
                    Target = _timelineNode,
                    Property = "modulate",
                    EndState = Colors.White
                }
            ];
            this.AnimateMultiple(UIAnimation.LinearEaseInOut(), propertiesToAnimate, true, () =>
            {
                GetTree().Paused = true;
                _timelineNode.Visible = true;
                _timelineNode.StartTimeline();
            });
        };

        // Show/hide interaction HUD tutorials whenever the player is in range.
        RollinsportMessageBus.Instance.PlayerInteractionEnteredRange += () =>
        {
            _tutorialInteractNode.Visible = true;
            this.Animate(UIAnimation.LinearEaseInOut(_tutorialInteractFadeTime), new UIAnimationProperty
            {
                Target = _tutorialInteractNode,
                Property = "modulate",
                EndState = Colors.White
            });
        };
        RollinsportMessageBus.Instance.PlayerInteractionExitedRange += () =>
        {
            this.Animate(UIAnimation.InterpolatingSpring(), new UIAnimationProperty
            {
                Target = _tutorialInteractNode,
                Property = "modulate",
                EndState = Colors.Transparent
            }, () =>
            {
                _tutorialInteractNode.Visible = false;
            });
        };

        // NOTE: Fire this off here, because doing so in RollinsportMessageBus is too early. Fucking race conditions, man!
        RollinsportMessageBus.Instance.SendMessage(RollinsportMessageBus.PlayerManagementMessage.RequestPlayerBirth, Vector2.Zero);
    }

    public override void _UnhandledKeyInput(InputEvent @event)
    {
        this.Animate(UIAnimation.InterpolatingSpring(), new UIAnimationProperty
        {
            Target = _tutorialMovementNode,
            Property = "modulate",
            EndState = Colors.Transparent
        }, () =>
        {
            _tutorialMovementNode.Visible = false;
        });
    }
}
