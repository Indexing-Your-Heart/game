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
using IndexingYourHeart.Utils;

namespace IndexingYourHeart.Entities;

/// <summary>
/// A character node that the player controls and interacts with.
/// </summary>
[Tool]
public partial class AnthroPlayer : CharacterBody2D
{
    /// <summary>
    /// A representation of the different characters the player can be.
    /// </summary>
    public enum Character
    {
        Chelsea,
        Obel
    }

    /// <summary>
    /// The player's current movement state.
    /// </summary>
    public enum PlayerState
    {
        /// <summary>
        /// The player is idle and not actively moving.
        /// </summary>
        Idle,
        
        /// <summary>
        /// The player is currently walking around with manual controls. Used for the desktop versions of the game, or
        /// versions of a game with manual control mechanisms such as keyboard and mouse, controller, etc.
        /// </summary>
        Walking,
        
        /// <summary>
        /// The player is currently walking toward a target automatically. Used for the mobile versions of the game.
        /// </summary>
        Navigating
    }
    
    /// <summary>
    /// The player's current character model.
    /// </summary>
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
    
    #region Physics
    /// <summary>
    /// The rate at which the player will accelerate.
    /// </summary>
    [ExportCategory("Physics")]
    [Export] public int Acceleration = 250;
    
    /// <summary>
    /// The rate at which the player will encounter friction.
    /// </summary>
    [Export] public int Friction = 100;
    
    /// <summary>
    /// The rate at which the player moves.
    /// </summary>
    [Export] public int Speed = 200;
    #endregion

    #region Children

    private Camera2D _camera;
    private AnimationTree _animationTree;
    private AnimationPlayer _animationPlayer;
    private NavigationAgent2D _navigator;
    private Sprite2D _sprite;
    private AudioStreamPlayer2D _footstepsStream;

    #endregion

    private AnimationNodeStateMachinePlayback _animationState;
    private PlayerState _playerState;
    private Sprite2D _indicator;
    private Character _character = Character.Chelsea;

    private static Vector2 movementVector => Input.GetVector(
        "move_left", "move_right", "move_up", "move_down")
        .Normalized();

    public override void _Ready()
    {
        base._Ready();

        _camera = GetNode<Camera2D>("Camera");
        _animationTree = GetNode<AnimationTree>("Sprite/AnimationTree");
        _animationPlayer = GetNode<AnimationPlayer>("Sprite/AnimationPlayer");
        _navigator = GetNode<NavigationAgent2D>("Navigator");
        _sprite = GetNode<Sprite2D>("Sprite");
        _footstepsStream = GetNode<AudioStreamPlayer2D>("Footsteps");

        _animationTree.Active = !Engine.IsEditorHint();
        _animationState = (AnimationNodeStateMachinePlayback)_animationTree.Get("parameters/playback");

        _navigator.PathDesiredDistance = 4;
        _navigator.TargetDesiredDistance = 4;

        RollinsportMessageBus.Instance.RequestPlayerReposition += (globalPosition) =>
        {
            GlobalPosition = globalPosition;
        };

        RollinsportMessageBus.Instance.RequestPlayerLocation += delegate
        {
            RollinsportMessageBus.Instance.SendMessage(
                RollinsportMessageBus.PlayerManagementMessage.LocationReported, GlobalPosition);
        };
    }

    public override void _UnhandledInput(InputEvent @event)
    {
        base._UnhandledInput(@event);

        if (!@event.IsClass("InputEventScreenTouch") || !@event.IsPressed()) return;
        var newPosition = (Vector2)@event.Get("position");
        newPosition *= GetViewport().CanvasTransform;

        GetTree().PhysicsFrame += () => CallDeferred(nameof(MoveToward), newPosition);
    }

    public override void _Process(double delta)
    {
        base._Process(delta);
        if (_indicator != null && GlobalPosition.DistanceTo(_indicator.Position) < 32)
            _indicator.Visible = false;
    }

    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);
        if (Engine.IsEditorHint())
            return;

        if (_playerState == PlayerState.Navigating)
        {
            NavigateToNextTarget();
            UpdateStateConditions();
            return;
        }

        if (movementVector != Vector2.Zero)
        {
            _playerState = PlayerState.Walking;
            UpdateBlendingProperties(movementVector);
            Velocity = Accelerated(movementVector);
        }
        else
        {
            _playerState = PlayerState.Idle;
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
        _sprite.Texture = _character switch
        {
            Character.Chelsea => GD.Load<Texture2D>("res://resources/sprt_chelsea.png"),
            Character.Obel => GD.Load<Texture2D>("res://resources/sprt_obel.png"),
            _ => _sprite.Texture
        };
    }

    private void MoveToward(Vector2 destination)
    {
        _playerState = PlayerState.Navigating;
        _navigator.TargetPosition = destination;

        if (_indicator != null)
        {
            _indicator.Visible = true;
            _indicator.GlobalPosition = destination;
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
            _indicator = newSprite;
        }
    }

    private void NavigateToNextTarget()
    {
        Vector2 nextPosition = _navigator.GetNextPathPosition();
        if (_navigator.IsTargetReached() || nextPosition == GlobalPosition)
        {
            _playerState = PlayerState.Idle;
            _indicator.Visible = false;
            return;
        }

        Vector2 newVelocity = nextPosition - GlobalPosition;
        UpdateBlendingProperties(Accelerated(newVelocity, true));
        Velocity = newVelocity;
        MoveAndSlide();
    }
    
    private void UpdateBlendingProperties(Vector2 vector)
    {
        _animationTree.Set("parameters/Idle/blend_position", vector);
        _animationTree.Set("parameters/Walk/blend_position", vector);
    }

    private void UpdateStateConditions()
    {
        _animationTree.Set("parameters/conditions/idling", _playerState == PlayerState.Idle);
        _animationTree.Set("parameters/conditions/walking", _playerState != PlayerState.Idle);
        
        switch (_playerState)
        {
            case PlayerState.Idle:
                _footstepsStream.Stop();
                break;
            
            case PlayerState.Walking:
            case PlayerState.Navigating:
            default:
                if (!_footstepsStream.Playing)
                    _footstepsStream.Play();
                break;
        }
    }
}
