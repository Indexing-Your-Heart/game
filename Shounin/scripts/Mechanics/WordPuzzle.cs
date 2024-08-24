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
using IndexingYourHeart.Utils;

namespace IndexingYourHeart.Mechanics;

/// <summary>
/// A node that contains a word puzzle fixture which can be interacted with by approaching it and pressing the interact key.
/// </summary>
public partial class WordPuzzle : Node2D
{
    /// <summary>
    /// The node path to the text field to attach in the scene tree.
    /// </summary>
    [Export]
    public NodePath TextFieldPath;
    
    /// <summary>
    /// The text value of the expected solution.
    /// </summary>
    [ExportGroup("Puzzle Data")]
    [Export]
    public string ExpectedSolution;

    /// <summary>
    /// A unique identifier for the puzzle.
    /// </summary>
    /// <remarks>
    /// Systems such as the <see cref="RollinsportMessageBus"/> leverage this information to save and restore puzzle data.
    /// </remarks>
    [Export]
    public string PuzzleId;
    
    /// <summary>
    /// The text field driving the puzzle interaction, derived from <see cref="TextFieldPath"/>.
    /// </summary>
    public PuzzleTextField textField { get; private set; }

    private Area2D _detectionRing;
    private bool _eligibleToLaunch = false;

    public override void _Ready()
    {
        base._Ready();

        _detectionRing = GetNode<Area2D>("Area2D");
        textField = GetNode<PuzzleTextField>(TextFieldPath);

        textField.TextFieldReturned += TextFieldReturned;
        textField.TextFieldChangedInput += delegate
        {
            textField.StopAnimations();
        };

        _detectionRing.BodyEntered += BodyEnteredRange;
        _detectionRing.BodyExited += delegate
        {
            _eligibleToLaunch = false;
            textField.Clear();
            textField.Hide();
        };

        RollinsportMessageBus.Instance.FoundSolution += id =>
        {
            if (!_eligibleToLaunch || id != PuzzleId)
                return;
            textField.Prefill(ExpectedSolution);
        };
    }

    public override void _UnhandledInput(InputEvent @event)
    {
        base._UnhandledInput(@event);
        
        if (Input.IsActionPressed("interact") && _eligibleToLaunch)
        {
            textField.Show();
            return;
        }

        if (!Input.IsActionPressed("cancel") || !_eligibleToLaunch) return;
        textField.Hide();
    }

    private void BodyEnteredRange(Node2D body)
    {
        _eligibleToLaunch = body is AnthroPlayer;
        textField.Clear();

        RollinsportMessageBus.Instance.SendMessage(
            RollinsportMessageBus.PuzzleSolutionMessage.RequestForSolution,
            PuzzleId);
        
        if (DisplayServer.IsTouchscreenAvailable() && _eligibleToLaunch)
        {
            textField.Show();
        }
    }

    private void TextFieldReturned(string value)
    {
        if (!_eligibleToLaunch)
            return;

        if (value != ExpectedSolution)
        {
            textField.MarkIncorrect();
            return;
        }

        RollinsportMessageBus.Instance.SendMessage(RollinsportMessageBus.PuzzleSolutionMessage.PuzzleSolved, PuzzleId);

        textField.MarkCorrect();
    }
}
