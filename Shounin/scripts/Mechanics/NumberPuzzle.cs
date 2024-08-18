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

// TODO: Write integration tests!

public partial class NumberPuzzle : Node2D
{
    [Export]
    public NodePath Numpad;
    
    [ExportGroup("Puzzle Data")]
    [Export(PropertyHint.Range, "0,31,1")]
    public int ExpectedSolution;

    [Export]
    public string PuzzleId;

    private bool eligibleToLaunch;
    private PuzzleNumpadField puzzleFieldNumpad;

    private Area2D detectionRing;

    public override void _Ready()
    {
        base._Ready();
        detectionRing = GetNode<Area2D>("Area2D");
        puzzleFieldNumpad = GetNode<PuzzleNumpadField>(Numpad);

        detectionRing.BodyEntered += BodyEnteredRange;
        detectionRing.BodyExited += delegate
        {
            eligibleToLaunch = false;
            puzzleFieldNumpad.Hide();
            puzzleFieldNumpad.Clear();
        };

        puzzleFieldNumpad.EditingChanged += value =>
        {
            if (!eligibleToLaunch)
                return;
            if (value != ExpectedSolution)
            {
                puzzleFieldNumpad.MarkIncorrect();
                return;
            }
            puzzleFieldNumpad.MarkCorrect();
            
            RollinsportMessageBus.Instance.SendMessage(
                RollinsportMessageBus.PuzzleSolutionMessage.PuzzleSolved,
                PuzzleId
            );
        };

        RollinsportMessageBus.Instance.FoundSolution += id =>
        {
            if (!eligibleToLaunch || id != PuzzleId)
                return;
            puzzleFieldNumpad.Prefill(ExpectedSolution);
        };
    }

    public override void _UnhandledInput(InputEvent @event)
    {
        if (Input.IsActionPressed("interact") && eligibleToLaunch)
        {
            puzzleFieldNumpad.Show();
            return;
        }

        if (Input.IsActionPressed("cancel") && eligibleToLaunch)
        {
            puzzleFieldNumpad.Hide();
            return;
        }
    }

    private void BodyEnteredRange(Node2D body)
    {
        eligibleToLaunch = body is AnthroPlayer;

        RollinsportMessageBus.Instance.SendMessage(
            RollinsportMessageBus.PuzzleSolutionMessage.RequestForSolution,
            PuzzleId
        );
        
        if (DisplayServer.IsTouchscreenAvailable() && eligibleToLaunch)
        {
            puzzleFieldNumpad.Show();
        }
    }
}
