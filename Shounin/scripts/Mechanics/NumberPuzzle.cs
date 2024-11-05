#region Copyright
// NumberPuzzle.cs
// Indexing Your Heart
// 
// Created by Marquis Kurt on 11/08/2024.
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
using IndexingYourHeart.Entities;
using IndexingYourHeart.UI;
using IndexingYourHeart.Utils;

namespace IndexingYourHeart.Mechanics;

/// <summary>
/// A node that provides a puzzle using the numpad.
/// </summary>
public partial class NumberPuzzle : Node2D
{
    /// <summary>
    /// The node path to the numpad to attach in the scene tree.
    /// </summary>
    [Export]
    public NodePath Numpad;

    /// <summary>
    /// The numeric value of the expected solution.
    /// </summary>
    [ExportGroup("Puzzle Data")]
    [Export(PropertyHint.Range, "0,31,1")]
    public int ExpectedSolution;

    /// <summary>
    /// A unique identifier for the puzzle.
    /// </summary>
    /// <remarks>
    /// Systems such as the <see cref="RollinsportMessageBus"/> leverage this information to save and restore puzzle data.
    /// </remarks>
    [Export]
    public string PuzzleId;

    private bool _eligibleToLaunch;
    private PuzzleNumpadField _puzzleFieldNumpad;

    private Area2D _detectionRing;

    public override void _Ready()
    {
        base._Ready();
        _detectionRing = GetNode<Area2D>("Area2D");
        _puzzleFieldNumpad = GetNode<PuzzleNumpadField>(Numpad);

        _detectionRing.BodyEntered += BodyEnteredRange;
        _detectionRing.BodyExited += delegate
        {
            _eligibleToLaunch = false;
            _puzzleFieldNumpad.Hide();
            _puzzleFieldNumpad.Clear();
            RollinsportMessageBus.Instance.SendMessage(RollinsportMessageBus.PlayerInteractionMessage.ExitedRange);
        };

        _puzzleFieldNumpad.EditingChanged += value =>
        {
            if (!_eligibleToLaunch)
                return;
            if (value != ExpectedSolution)
            {
                _puzzleFieldNumpad.MarkIncorrect();
                return;
            }
            _puzzleFieldNumpad.MarkCorrect();

            RollinsportMessageBus.Instance.SendMessage(
                RollinsportMessageBus.PuzzleSolutionMessage.PuzzleSolved,
                PuzzleId
            );
        };

        RollinsportMessageBus.Instance.FoundSolution += id =>
        {
            if (!_eligibleToLaunch || id != PuzzleId)
                return;
            _puzzleFieldNumpad.Prefill(ExpectedSolution);
        };
    }

    public override void _UnhandledInput(InputEvent @event)
    {
        if (Input.IsActionPressed("interact") && _eligibleToLaunch)
        {
            _puzzleFieldNumpad.Show();
            return;
        }

        if (Input.IsActionPressed("cancel") && _eligibleToLaunch)
        {
            _puzzleFieldNumpad.Hide();
            return;
        }
    }

    private void BodyEnteredRange(Node2D body)
    {
        _eligibleToLaunch = body is AnthroPlayer;

        if (_eligibleToLaunch)
        {
            RollinsportMessageBus.Instance.SendMessage(RollinsportMessageBus.PlayerInteractionMessage.EnteredRange);
        }

        RollinsportMessageBus.Instance.SendMessage(
            RollinsportMessageBus.PuzzleSolutionMessage.RequestForSolution,
            PuzzleId
        );

        if (DisplayServer.IsTouchscreenAvailable() && _eligibleToLaunch)
        {
            _puzzleFieldNumpad.Show();
        }
    }
}
