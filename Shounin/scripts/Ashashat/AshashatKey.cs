#region Copyright
// AshashatKey.cs
// Indexing Your Heart
// 
// Created by Marquis Kurt on 30/07/2024.
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

using System;

namespace IndexingYourHeart.Ashashat;

public enum AshashatKey
{
    A, I, E, U,
    P, B, T, K, N, S, L,
    EjectiveK, Sh, Glottal,
    Repeater, Duplicant, Return, Delete
}

public static class AshashatKeyExtensions
{
    /// <summary>
    /// Provides the keyboard value of the specified key. When appending to a text field, this value should be used.
    /// </summary>
    /// <param name="key">The key to determine the value of.</param>
    /// <returns>
    /// The keyboard value of the specified key. Special keys, such as <c>Delete</c> or <c>Return</c>, return an empty
    /// string value instead.
    /// </returns>
    public static string KeyValue(this AshashatKey key) => key switch
    {
        // Vowels
        AshashatKey.A => "a",
        AshashatKey.E => "e",
        AshashatKey.I => "i",
        AshashatKey.U => "u",
        
        // Consonant diacritics
        AshashatKey.P => "p",
        AshashatKey.B => "b",
        AshashatKey.T => "t",
        AshashatKey.K => "k",
        AshashatKey.N => "n",
        AshashatKey.S => "s",
        AshashatKey.L => "l",
        AshashatKey.Sh => "ʃ",
        AshashatKey.Glottal => "ʔ",
        
        // Special keys
        AshashatKey.Repeater => ":",
        AshashatKey.Duplicant => "!",
        AshashatKey.EjectiveK => "k'",
        
        // Keys with no values
        _ => ""
    };

    /// <summary>
    /// The key's value as rendered using the [ʔaʃaʃat] fonts.
    /// </summary>
    /// <remarks>
    /// [iʔaʃakasubapenasate] renders characters using font ligatures. As such, typically, some key combinations don't
    /// necessarily match <see cref="KeyValue"/>. This should be used for labels that set their font to be a variant of
    /// the [iʔaʃakasubapenasate] family.
    /// </remarks>
    /// <param name="key">The key to get the font rendered value of.</param>
    /// <returns>The key's value as rendered using the [ʔaʃaʃat] fonts.</returns>
    public static string FontRenderedValue(this AshashatKey key) => key switch
    {
        AshashatKey.Repeater => "*",
        AshashatKey.EjectiveK => "K",
        AshashatKey.Sh => "sh",
        _ => KeyValue(key)
    };

    /// <summary>
    /// The key's registered key code.
    /// </summary>
    /// <remarks>
    /// When the <c>ashashat_key_pressed</c> signal is emitted from keyboard interpreters, this key code will be
    /// provided as an argument.
    /// </remarks>
    /// <param name="key">The key to get the key code of.</param>
    /// <returns>The key's registered key code.</returns>
    public static string KeyCode(this AshashatKey key) => $"ashashat_key_{KeyValue(key)}";
}
