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
    private Control _tutorialMovementNode;
    private Control _tutorialInteractNode;

    private const double _tutorialInteractFadeTime = 0.25;

    public override void _Ready()
    {
        base._Ready();
        _tutorialMovementNode = GetNode<Control>("CanvasLayer/TutorialMovement");
        _tutorialInteractNode = GetNode<Control>("CanvasLayer/TutorialInteract");

        _tutorialInteractNode.Modulate = Colors.Transparent;

        // Show movement tutorial when the player is just starting.
        RollinsportMessageBus.Instance.PlayerGivenBirth += () =>
        {
            _tutorialMovementNode.Visible = true;
        };

        // Show/hide interaction HUD tutorials whenever the player is in range.
        RollinsportMessageBus.Instance.PlayerInteractionEnteredRange += () =>
        {
            GD.Print("Player interaction entered");
            _tutorialInteractNode.Visible = true;
            Tween animator = CreateTween().SetEase(Tween.EaseType.InOut).SetTrans(Tween.TransitionType.Linear).Parallel();
            animator.TweenProperty(_tutorialInteractNode, "modulate", Colors.White, _tutorialInteractFadeTime);
        };
        RollinsportMessageBus.Instance.PlayerInteractionExitedRange += () =>
        {
            Tween animator = CreateTween().SetEase(Tween.EaseType.InOut).SetTrans(Tween.TransitionType.Linear).Parallel();
            animator.TweenProperty(_tutorialInteractNode, "modulate", Colors.Transparent, _tutorialInteractFadeTime);
            animator.Finished += () =>
            {
                _tutorialInteractNode.Visible = false;
            };
        };

        // NOTE: Fire this off here, because doing so in RollinsportMessageBus is too early. Fucking race conditions, man!
        RollinsportMessageBus.Instance.SendMessage(RollinsportMessageBus.PlayerManagementMessage.RequestPlayerBirth, Vector2.Zero);
    }

    public override void _UnhandledKeyInput(InputEvent @event)
    {
        Tween animator = CreateTween().SetEase(Tween.EaseType.Out).SetTrans(Tween.TransitionType.Linear).Parallel();
        animator.TweenProperty(_tutorialMovementNode, "modulate", Colors.Transparent, 0.5);
        animator.Finished += () =>
        {
            _tutorialMovementNode.Visible = false;
        };
    }
}
