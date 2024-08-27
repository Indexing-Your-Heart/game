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

/// <summary>
/// A class responsible for delegating messages sent across nodes and scenes in a simple manner.
/// </summary>
/// <remarks>
/// <para>
/// The message bus is typically used for interdependent messages that apply across various systems, such as listening for when
/// puzzles are solved or saving/loading the world state. Normally, the shared <see cref="Instance"/> is referenced to handle
/// event listeners.
/// </para>
///
/// <para>
/// Messages should be sent via the <c>SendMessage</c> methods, rather than using <see cref="Node.EmitSignal"/>, as these methods
/// guarantee type safety and limit the scope of the message contents:
/// <code>
/// RollinsportMessageBus.Instance.SendMessage(PuzzleSolutionMessage.RequestForSolution, "pzl_example");
/// </code>
/// </para>
/// </remarks>
[GlobalClass]
public partial class RollinsportMessageBus : Node
{
    /// <summary>
    /// Messages that are specific to puzzle solutions. These messages will often provide the puzzle's ID.
    /// </summary>
    public enum PuzzleSolutionMessage
    {
        /// <summary>
        /// A puzzle is querying whether it has already been solved by the player per the player file.
        /// </summary>
        RequestForSolution,
        
        /// <summary>
        /// A puzzle has been found in the completed list.
        /// </summary>
        FoundSolution,
        
        /// <summary>
        /// A puzzle was recently solved.
        /// </summary>
        PuzzleSolved
    }

    /// <summary>
    /// Messages that are specific to player management.
    /// </summary>
    public enum PlayerManagementMessage
    {
        /// <summary>
        /// A query for the player's current location is being requested.
        /// </summary>
        RequestPlayerLocation,
        
        /// <summary>
        /// The player's location is being reported.
        /// </summary>
        LocationReported
    }
    
    /// <summary>
    /// A shared instance of the message bus for globally setting event listeners.
    /// </summary>
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
    
    /// <summary>
    /// Send a message to the message bus, passing it to all its listeners.
    /// </summary>
    /// <param name="message">The message to send to the message bus's listeners.</param>
    /// <param name="puzzleId">The ID of the puzzle to provide with the message.</param>
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

    /// <summary>
    /// Send a message to the message bus, passing it to all its listeners.
    /// </summary>
    /// <param name="message">The message to send to the message bus's listeners.</param>
    /// <param name="position">The player's current position (or <c>Vector2.Zero</c>) to provide with the message.</param>
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

    #region Player Management Signals
    /// <summary>
    /// A signal emitted whenever the player's location is requested (i.e.,
    /// <see cref="PlayerManagementMessage.RequestPlayerLocation"/> was sent to the message bus).
    /// </summary>
    [Signal]
    public delegate void RequestPlayerLocationEventHandler();

    /// <summary>
    /// A signal emitted whenever the player's location is being reported (i.e.,
    /// <see cref="PlayerManagementMessage.LocationReported"/> was sent to the message bus). The player's location is provided as
    /// its single argument.
    /// </summary>
    [Signal]
    public delegate void PlayerLocationReportedEventHandler(Vector2 globalPosition);

    /// <summary>
    /// A signal emitted whenever a request is made to reposition the player.
    /// </summary>
    /// <remarks>
    /// This is a receiver-only signal.
    /// </remarks>
    [Signal]
    public delegate void RequestPlayerRepositionEventHandler(Vector2 globalPosition);
    #endregion
    
    #region Puzzle Solution Signals
    /// <summary>
    /// A signal emitted whenever a puzzle or system is querying whether it has been solved by the player before (i.e.,
    /// <see cref="PuzzleSolutionMessage.RequestForSolution"/> was sent to the message bus).
    /// </summary>
    [Signal]
    public delegate void RequestForSolutionEventHandler(string puzzleId);

    /// <summary>
    /// A signal emitted whenever a system has detected a puzzle that has been solved already (i.e.,
    /// <see cref="PuzzleSolutionMessage.FoundSolution"/> was send to the message bus).
    /// </summary>
    [Signal]
    public delegate void FoundSolutionEventHandler(string puzzleId);

    /// <summary>
    /// A signal emitted whenever a puzzle has been solved (i.e., <see cref="PuzzleSolutionMessage.PuzzleSolved"/> was sent to the
    /// message bus).
    /// </summary>
    [Signal]
    public delegate void PuzzleSolvedEventHandler(string puzzleId);
    #endregion
}
