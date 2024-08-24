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
using IndexingYourHeart.Mechanics;
using System;
using System.IO;
using System.Linq;
using FileAccess = Godot.FileAccess;

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

    public enum PlayerManagementMessage
    {
        RequestPlayerLocation,
        LocationReported
    }
    
    public static RollinsportMessageBus Instance { get; private set; }

    private Array<string> _puzzles = [];
    private Vector2 _playerGlobalPosition = Vector2.Zero;

    private const string PlayerfileLocation = "user://Playerfile";

    public override void _Ready()
    {
        Instance = this;

        LoadFromSaveData();

        RequestForSolution += (id) =>
        {
            if (!_puzzles.Contains(id))
                return;
            SendMessage(PuzzleSolutionMessage.FoundSolution, id);
        };
        PuzzleSolved += _puzzles.Add;

        PlayerLocationReported += (globalPosition) => _playerGlobalPosition = globalPosition;
        
        // Save the player data to a file when exiting.
        TreeExiting += () => SendMessage(PlayerManagementMessage.RequestPlayerLocation, _playerGlobalPosition);
        TreeExited += SaveDataToFile;

    }

    private void SaveDataToFile()
    {
        Playerfile savedPlayerFile = new([_playerGlobalPosition.X, _playerGlobalPosition.Y], _puzzles.ToArray());
        using FileAccess saveFile = FileAccess.Open(PlayerfileLocation, FileAccess.ModeFlags.Write);
        saveFile.StoreString(savedPlayerFile.ToJson());
    }

    private void LoadFromSaveData()
    {
        if (!FileAccess.FileExists(PlayerfileLocation))
            return;
        
        using FileAccess file = FileAccess.Open(PlayerfileLocation, FileAccess.ModeFlags.Read);
        string textContents = file.GetAsText();
        Playerfile playerFile = Playerfile.Deserialized(textContents);

        _puzzles = new Array<string>(playerFile.SolvedPuzzles);
        Vector2 globalPosition = playerFile.RealizedPlayerPosition();
        _playerGlobalPosition = globalPosition;

        CallDeferred("emit_signal", nameof(SignalName.RequestPlayerReposition), globalPosition);
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
            default:
                throw new ArgumentOutOfRangeException(nameof(message), message, null);
        }
    }

    public void SendMessage(PlayerManagementMessage message, Vector2 position)
    {
        switch (message)
        {
            case PlayerManagementMessage.LocationReported:
                EmitSignal(SignalName.PlayerLocationReported, position);
                break;
            case PlayerManagementMessage.RequestPlayerLocation:
                EmitSignal(SignalName.RequestPlayerLocation);
                break;
            default:
                throw new ArgumentOutOfRangeException(nameof(message), message, null);
        }
    }

    #region Player Management Signals
    [Signal]
    public delegate void RequestPlayerLocationEventHandler();

    [Signal]
    public delegate void PlayerLocationReportedEventHandler(Vector2 globalPosition);

    [Signal]
    public delegate void RequestPlayerRepositionEventHandler(Vector2 globalPosition);
    #endregion
    
    #region Puzzle Solution Signals
    [Signal]
    public delegate void RequestForSolutionEventHandler(string puzzleId);

    [Signal]
    public delegate void FoundSolutionEventHandler(string puzzleId);

    [Signal]
    public delegate void PuzzleSolvedEventHandler(string puzzleId);
    #endregion
}
