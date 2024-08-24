#region Copyright
// WordPuzzle_IntegrationTestNode.cs
// Indexing Your Heart
// 
// Created by Marquis Kurt on 22/08/2024.
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
using IndexingYourHeart.Mechanics;
using IndexingYourHeart.UI;
using IndexingYourHeart.Utils;

namespace IndexingYourHeart.Tests.Backing;

public partial class WordPuzzle_IntegrationTestNode : Node2D
{
    private WordPuzzle _wordPuzzle;
    private bool _puzzleSolved;

    public override void _Ready()
    {
        base._Ready();
        _wordPuzzle = GetNode<WordPuzzle>("Puzzle Point");
        _puzzleSolved = false;
        
        RollinsportMessageBus.Instance.PuzzleSolved += (_) => _puzzleSolved = true;
    }

    public void GrabKeyboardFocus()
    {
        _wordPuzzle.textField.GrabKeyboardFocus();
    }

    public bool PuzzleVisible() => _wordPuzzle.textField.Visible;
    public bool PuzzleSolved() => _puzzleSolved;
}
