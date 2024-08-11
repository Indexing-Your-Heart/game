#region Copyright
// WordPuzzle.cs
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

namespace IndexingYourHeart.Mechanics;

// TODO: Write integration tests!

public partial class WordPuzzle : Node2D
{
    [Export]
    public NodePath TextField;
    
    [ExportGroup("Puzzle Data")]
    [Export]
    public string ExpectedSolution;

    [Export]
    public string PuzzleId;

    private Area2D detectionRing;
    private PuzzleTextField textField;
    private bool eligibleToLaunch = false;

    public override void _Ready()
    {
        base._Ready();

        detectionRing = GetNode<Area2D>("Area2D");
        textField = GetNode<PuzzleTextField>(TextField);

        textField.TextFieldReturned += TextFieldReturned;
        textField.TextFieldChangedInput += delegate
        {
            textField.StopAnimations();
        };

        detectionRing.BodyEntered += BodyEnteredRange;
        detectionRing.BodyExited += delegate
        {
            eligibleToLaunch = false;
            textField.Clear();
            textField.Hide();
        };
    }

    public override void _UnhandledInput(InputEvent @event)
    {
        base._UnhandledInput(@event);
        if (Input.IsActionPressed("interact") && eligibleToLaunch)
        {
            textField.Show();
            return;
        }

        if (Input.IsActionPressed("cancel") && eligibleToLaunch)
        {
            textField.Hide();
            return;
        }
    }

    private void BodyEnteredRange(Node2D body)
    {
        eligibleToLaunch = body is AnthroPlayer;
        textField.Clear();
        
        if (DisplayServer.IsTouchscreenAvailable() && eligibleToLaunch)
        {
            textField.Show();
        }
    }

    private void TextFieldReturned(string value)
    {
        if (!eligibleToLaunch)
            return;

        if (value != ExpectedSolution)
        {
            textField.MarkIncorrect();
            return;
        }
        
        // TODO: Add signal emission for complete.

        textField.MarkCorrect();
    }
}
