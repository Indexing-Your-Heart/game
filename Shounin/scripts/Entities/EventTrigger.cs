#region Copyright
// EventTrigger.cs
// Indexing Your Heart
// 
// Created by Marquis Kurt on 04/07/2025.
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
using System;

namespace IndexingYourHeart.Entities;

/// <summary>
/// An area node used to run specific global triggers.
/// </summary>
/// <remarks>
/// Use event triggers when trying to perform a global action from entering or exiting a zone such as displaying a
/// cutscene, saving the current state, or triggering a scripted event to play.
/// </remarks>
[Tool]
public partial class EventTrigger : Area2D
{
    /// <summary>
    /// The different types of triggers that can be executed when the player passes through.
    /// </summary>
    public enum TriggerType
    {
        /// <summary>
        /// Show a specific timeline to the screen. <see cref="EventTrigger.TriggerValue"/> represents the file to the
        /// Jenson script to load.
        /// </summary>
        ShowTimeline,

        /// <summary>
        /// Save the current Playerfile to disk.
        /// </summary>
        SavePlayerfile
    }

    /// <summary>
    /// The different ways a trigger can be retriggered.
    /// </summary>
    public enum Retrigger
    {
        /// <summary>
        /// The trigger only triggers once.
        /// </summary>
        Once,

        /// <summary>
        /// The trigger executes every time the player has entered it.
        /// </summary>
        Always
    }

    /// <summary>
    /// The action this trigger will perform.
    /// </summary>
    [Export]
    public TriggerType Trigger = TriggerType.ShowTimeline;

    /// <summary>
    /// How often this trigger can re-execute when the player re-enters it.
    /// </summary>
    [Export]
    public Retrigger RetriggerCondition
    {
        get => _retrigger;
        set
        {
            _retrigger = value;
            RecolorCollisionShapeIfAvailable();
        }
    }

    /// <summary>
    /// The data value for the trigger.
    /// </summary>
    [Export]
    public string TriggerValue = string.Empty;

    /// <summary>
    /// The general shape of the trigger.
    /// </summary>
    [Export]
    public Shape2D TriggerShape
    {
        get => _triggerShape;
        set
        {
            _triggerShape = value;
            var collisionShape = GetNode<CollisionShape2D>("CollisionShape2D");
            if (collisionShape != null)
                collisionShape.Shape = _triggerShape;
        }
    }

    private Retrigger _retrigger = Retrigger.Once;
    private Shape2D _triggerShape;
    private int triggers;

    public override void _Ready()
    {
        BodyEntered += BodyEnteredTrigger;
        RecolorCollisionShapeIfAvailable();
        var debugText = GetNode<Label>("Label");
        debugText.Visible = Engine.IsEditorHint();
    }

    private void RecolorCollisionShapeIfAvailable()
    {
        if (!Engine.IsEditorHint()) return;
        var collisionShape = GetNode<CollisionShape2D>("CollisionShape2D");
        if (collisionShape == null) return;

        collisionShape.DebugColor = _retrigger switch
        {
            Retrigger.Once => Colors.Cyan,
            Retrigger.Always => Colors.Orange,
            _ => throw new ArgumentOutOfRangeException(nameof(RetriggerCondition), RetriggerCondition, null)
        };
        collisionShape.DebugColor = Color.Color8(
            (byte)collisionShape.DebugColor.R8,
            (byte)collisionShape.DebugColor.G8,
            (byte)collisionShape.DebugColor.B8,
            127);
    }

    private void BodyEnteredTrigger(Node body)
    {
        if (body is not AnthroPlayer) return;
        if (triggers == 1 && RetriggerCondition == Retrigger.Once) return;

        switch (Trigger)
        {
            case TriggerType.ShowTimeline:
                RollinsportMessageBus.Instance.SendMessage(RollinsportMessageBus.TimelineMessage.RequestTimeline, TriggerValue);
                break;
            case TriggerType.SavePlayerfile:
            default:
                GD.PushWarning($"Unrecognized trigger type: {Trigger}");
                break;
        }

        triggers++;
    }
}
