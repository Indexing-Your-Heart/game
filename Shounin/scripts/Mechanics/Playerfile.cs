#region Copyright
// Playerfile.cs
// Indexing Your Heart
// 
// Created by Marquis Kurt on 24/08/2024.
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
using System;
using System.Text.Json;

namespace IndexingYourHeart.Mechanics;

[Serializable]
public record EnvironmentData(string GameVersion, string Platform, string OperatingSystemVersion);

/// <summary>
///  A representation of a save file containing information about the player's saved state.
/// </summary>
public class Playerfile(float[] playerPosition, string[] solvedPuzzles, EnvironmentData environment)
{
    /// <summary>
    /// The version of the file. Some features and fields may only be available in later iterations.
    /// </summary>
    public int PlayerfileVersion { get; init; } = 1;

    /// <summary>
    /// Information about the game when the player file was created.
    /// </summary>
    public EnvironmentData Environment { get; init; } = environment;

    /// <summary>
    /// An array representation of the player's global position in the world. The first number is the X position, and the last
    /// number is the Y position.
    /// </summary>
    /// <remarks>
    /// To get a proper vector, use <see cref="RealizedPlayerPosition"/> instead. This field is only necessary for serialization
    /// and deserialization via JSON.
    /// </remarks>
    public float[] PlayerPosition { get; set; } = playerPosition;

    /// <summary>
    /// An array of all the current puzzle IDs the player has solved.
    /// </summary>
    public string[] SolvedPuzzles { get; init; } = solvedPuzzles;

    /// <summary>
    /// Create a player file by deserializing a JSON string.
    /// </summary>
    /// <param name="jsonString">The string that contains the JSON data to deserialize from.</param>
    /// <returns>A new player file with the appropriate data deserialized.</returns>
    public static Playerfile Deserialized(string jsonString)
    {
        return JsonSerializer.Deserialize<Playerfile>(jsonString);
    }

    /// <summary>
    /// Serializes the current file into a JSON string.
    /// </summary>
    /// <returns>A JSON string representation of the current player file object.</returns>
    public string ToJson() => JsonSerializer.Serialize(this);
    
    /// <summary>
    /// Realizes the player's global position from the player file.
    /// </summary>
    /// <returns>A Vector2 that represents the player's global position.</returns>
    public Vector2 RealizedPlayerPosition() => new(PlayerPosition[0], PlayerPosition[1]);
    
    /// <summary>
    /// Stores the player's global position as a float array for serialization.
    /// </summary>
    /// <param name="position">The position to be stored into the player file.</param>
    public void StorePlayerPosition(Vector2 position) => PlayerPosition = [position.X, position.Y];
}
