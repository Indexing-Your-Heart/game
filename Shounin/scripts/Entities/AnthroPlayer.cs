#region Copyright
//
// AnthroPlayer.cs
// Indexing Your Heart
// 
// Created by Marquis Kurt on 28/07/2024.
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

namespace IndexingYourHeart.Entities;

[Tool]
public partial class AnthroPlayer : CharacterBody2D
{
    public enum Character : int
    {
        Chelsea,
        Obel
    }

    public enum PlayerState
    {
        Idle,
        Walking,
        Navigating
    }

    // TODO: Make this an export category.
    [Export]
    public Character CurrentCharacter
    {
        get => _character;
        set
        {
            _character = value;
            if (!Engine.IsEditorHint())
                ChangeSprites();
        }
    }

    [ExportCategory("Physics")]
    [Export] public int Acceleration = 250;
    [Export] public int Friction = 100;
    [Export] public int Speed = 200;

    #region Children

    private Camera2D camera;
    private AnimationTree animationTree;
    private AnimationPlayer animationPlayer;
    private NavigationAgent2D navigator;
    private Sprite2D sprite;
    private AudioStreamPlayer2D footstepsStream;

    #endregion

    private AnimationNodeStateMachinePlayback animationState;
    private PlayerState playerState;
    private Sprite2D indicator;
    private Character _character = Character.Chelsea;

    private Vector2 movementVector => Input.GetVector(
        "move_left", "move_right", "move_up", "move_down")
        .Normalized();

    public override void _Ready()
    {
        base._Ready();

        camera = GetNode<Camera2D>("Camera");
        animationTree = GetNode<AnimationTree>("Sprite/AnimationTree");
        animationPlayer = GetNode<AnimationPlayer>("Sprite/AnimationPlayer");
        navigator = GetNode<NavigationAgent2D>("Navigator");
        sprite = GetNode<Sprite2D>("Sprite");
        footstepsStream = GetNode<AudioStreamPlayer2D>("Footsteps");

        animationTree.Active = !Engine.IsEditorHint();
        animationState = (AnimationNodeStateMachinePlayback)animationTree.Get("parameters/playback");

        navigator.PathDesiredDistance = 4;
        navigator.TargetDesiredDistance = 4;
    }

    public override void _UnhandledInput(InputEvent @event)
    {
        base._UnhandledInput(@event);

        if (!@event.IsClass("InputEventScreenTouch") || !@event.IsPressed()) return;
        Vector2 newPosition = (Vector2)@event.Get("position");
        newPosition *= GetViewport().CanvasTransform;

        GetTree().PhysicsFrame += () => CallDeferred(nameof(MoveToward), newPosition);
    }

    public override void _Process(double delta)
    {
        base._Process(delta);
        if (indicator != null && GlobalPosition.DistanceTo(indicator.Position) < 32)
            indicator.Visible = false;
    }

    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);
        if (Engine.IsEditorHint())
            return;

        if (playerState == PlayerState.Navigating)
        {
            NavigateToNextTarget();
            UpdateStateConditions();
            return;
        }

        if (movementVector != Vector2.Zero)
        {
            playerState = PlayerState.Walking;
            UpdateBlendingProperties(movementVector);
            Velocity = Accelerated(movementVector);
        }
        else
        {
            playerState = PlayerState.Idle;
            Velocity = Velocity.MoveToward(Vector2.Zero, Friction);
        }
        UpdateStateConditions();
        MoveAndSlide();

    }
    
    private Vector2 Accelerated(Vector2 vector, bool normalized = false)
    {
        Vector2 movement = vector;
        if (normalized)
            movement = movement.Normalized();
        return (movement * Acceleration).LimitLength(Speed);
    }

    private void ChangeSprites()
    {
        sprite.Texture = _character switch
        {
            Character.Chelsea => GD.Load<Texture2D>("res://resources/sprt_chelsea.png"),
            Character.Obel => GD.Load<Texture2D>("res://resources/sprt_obel.png"),
            _ => sprite.Texture
        };
    }

    private void MoveToward(Vector2 destination)
    {
        playerState = PlayerState.Navigating;
        navigator.TargetPosition = destination;

        if (indicator != null)
        {
            indicator.Visible = true;
            indicator.GlobalPosition = destination;
        }
        else
        {
            Sprite2D newSprite = new Sprite2D();
            newSprite.Texture = GD.Load<Texture2D>("res://resources/gui/tap_indicator.png");
            newSprite.TextureFilter = TextureFilterEnum.Nearest;
            newSprite.GlobalPosition = destination;
            newSprite.Name = "#TAPINDICATOR";
            newSprite.Scale = new Vector2(2, 2);
            newSprite.ZIndex = 4;
            GetParent().AddChild(newSprite);
            indicator = newSprite;
        }
    }

    private void NavigateToNextTarget()
    {
        Vector2 nextPosition = navigator.GetNextPathPosition();
        if (navigator.IsTargetReached() || nextPosition == GlobalPosition)
        {
            playerState = PlayerState.Idle;
            indicator.Visible = false;
            return;
        }

        Vector2 newVelocity = nextPosition - GlobalPosition;
        UpdateBlendingProperties(Accelerated(newVelocity, true));
        Velocity = newVelocity;
        MoveAndSlide();
    }
    
    private void UpdateBlendingProperties(Vector2 vector)
    {
        animationTree.Set("parameters/Idle/blend_position", vector);
        animationTree.Set("parameters/Walk/blend_position", vector);
    }

    private void UpdateStateConditions()
    {
        animationTree.Set("parameters/conditions/idling", playerState == PlayerState.Idle);
        animationTree.Set("parameters/conditions/walking", playerState != PlayerState.Idle);
        
        switch (playerState)
        {
            case PlayerState.Idle:
                footstepsStream.Stop();
                break;
            
            case PlayerState.Walking:
            case PlayerState.Navigating:
            default:
                if (!footstepsStream.Playing)
                    footstepsStream.Play();
                break;
        }
    }
}
