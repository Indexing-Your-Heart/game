#region Copyright
// AshashatKeyboard_UnitTestNode.cs
// Indexing Your Heart
// 
// Created by Marquis Kurt on 10/08/2024.
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

namespace IndexingYourHeart.Tests.Backing;

public partial class AshashatKeyboard_UnitTestNode : Control
{
    private string lastKeyPressed;
    private AshashatKeyboard keyboard;

    public override void _Ready()
    {
        base._Ready();
        keyboard = GetNode<AshashatKeyboard>("Keyboard");

        // Ensure that focus is maintained for the keyboard.
        var key = (Control)keyboard.GetNode("Main Grid/P Key");
        key.GrabFocus();

        keyboard.KeyPressed += (KeyCode) => { lastKeyPressed = KeyCode; };
    }

    public string GetLastKeyPressed() => lastKeyPressed;
}
