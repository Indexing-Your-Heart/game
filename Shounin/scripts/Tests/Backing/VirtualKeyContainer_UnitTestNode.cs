#region Copyright
// VirtualKeyContainer_UnitTestNode.cs
// Indexing Your Heart
// 
// Created by Marquis Kurt on 31/07/2024.
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

public partial class VirtualKeyContainer_UnitTestNode : Control
{
    private string LastKeyPressed;
    private VirtualAshashatKey key;
    private bool keyWasPressed = false;

    public override void _Ready()
    {
        base._Ready();
        key = GetNode<VirtualAshashatKey>("Key");
        key.Pressed += delegate
        {
            keyWasPressed = true;
        };
        key.KeyPressed += (keyCode) => LastKeyPressed = keyCode;
        key.GrabFocus();
    }

    public bool GetKeyWasPressed() => keyWasPressed;

    public string GetCurrentKeyCode()
    {
        return key == null ? "ERROR" : key.Key.KeyCode();
    }

    public string GetLastKeyPressed() => LastKeyPressed;
}
