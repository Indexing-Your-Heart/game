#region Copyright
// RollinsportMessageBus.cs
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
using Godot.Collections;

namespace IndexingYourHeart.Utils;

[GlobalClass]
public partial class RollinsportMessageBus : Node
{
    public enum PuzzleSolutionMessage
    {
        RequestForSolution,
        FoundSolution,
        PuzzleSolved
    }
    
    public static RollinsportMessageBus Instance { get; private set; }

    private Array<string> puzzles = [];

    public override void _Ready()
    {
        Instance = this;

        RequestForSolution += (id) =>
        {
            if (!puzzles.Contains(id))
                return;
            SendMessage(PuzzleSolutionMessage.FoundSolution, id);
        };
        PuzzleSolved += puzzles.Add;
    }

    public void SendMessage(PuzzleSolutionMessage message, string puzzleId)
    {
        switch (message)
        {
            case PuzzleSolutionMessage.RequestForSolution:
                EmitSignal(SignalName.RequestForSolution, puzzleId);
                break;
            case PuzzleSolutionMessage.FoundSolution:
                EmitSignal(SignalName.FoundSolution, puzzleId);
                break;
            case PuzzleSolutionMessage.PuzzleSolved:
                EmitSignal(SignalName.PuzzleSolved, puzzleId);
                break;
        }
    }
    
    [Signal]
    public delegate void RequestForSolutionEventHandler(string puzzleId);

    [Signal]
    public delegate void FoundSolutionEventHandler(string puzzleId);

    [Signal]
    public delegate void PuzzleSolvedEventHandler(string puzzleId);
}
