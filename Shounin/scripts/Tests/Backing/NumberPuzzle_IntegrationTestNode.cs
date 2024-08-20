#region Copyright
// NumberPuzzle_IntegrationTestNode.cs
// Indexing Your Heart
// 
// Created by Marquis Kurt on 18/08/2024.
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
using IndexingYourHeart.Ashashat;
using IndexingYourHeart.Mechanics;
using IndexingYourHeart.UI;
using IndexingYourHeart.Utils;

namespace IndexingYourHeart.Tests.Backing;

public partial class NumberPuzzle_IntegrationTestNode : Node2D
{
    private NumberPuzzle _numberPuzzle;
    private PuzzleNumpadField _numpad;
    
    private bool _puzzleSolved;

    public override void _Ready()
    {
        base._Ready();
        _numberPuzzle = GetNode<NumberPuzzle>("Puzzle Point");
        _numpad = GetNode<PuzzleNumpadField>("CanvasLayer/NumpadPuzzleField");
        _puzzleSolved = false;
        
        RollinsportMessageBus.Instance.PuzzleSolved += delegate { _puzzleSolved = true; };
    }

    public void GrabNumpadFocus()
    {
        _numpad.GetNode<Control>("VStack/Numpad/key1").GrabFocus();
    }
    
    public bool PuzzleSolved() => _puzzleSolved;
    public bool PuzzleVisible() => _numpad.Visible;
}
