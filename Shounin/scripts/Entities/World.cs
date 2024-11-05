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
using IndexingYourHeart.Utils;

namespace IndexingYourHeart.Entities;

public partial class World : Node2D
{
    private Control _tutorialNode;

    public override void _Ready()
    {
        base._Ready();
        _tutorialNode = GetNode<Control>("CanvasLayer/TutorialMovement");

        // Show movement and interaction tutorials when the player is just starting.
        RollinsportMessageBus.Instance.PlayerGivenBirth += () =>
        {
            _tutorialNode.Visible = true;
        };

        // NOTE: Fire this off here, because doing so in RollinsportMessageBus is too early. Fucking race conditions, man!
        RollinsportMessageBus.Instance.SendMessage(RollinsportMessageBus.PlayerManagementMessage.RequestPlayerBirth, Vector2.Zero);
    }

    public override void _UnhandledKeyInput(InputEvent @event)
    {
        Tween animator = CreateTween().SetEase(Tween.EaseType.Out).SetTrans(Tween.TransitionType.Linear).Parallel();
        animator.TweenProperty(_tutorialNode, "modulate", Colors.Transparent, 0.5);
        animator.Finished += () =>
        {
            _tutorialNode.Visible = false;
        };
    }
}
