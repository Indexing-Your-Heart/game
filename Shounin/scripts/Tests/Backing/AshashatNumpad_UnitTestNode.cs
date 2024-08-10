#region Copyright
// AshashatNumpad_UnitTestNode.cs
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

public partial class AshashatNumpad_UnitTestNode : Control
{
    private int currentNumpadNumber;
    private int returnedNumpadNumber;
    private AshashatNumpad numpad;

    public override void _Ready()
    {
        base._Ready();

        numpad = GetNode<AshashatNumpad>("Numpad");
        numpad.KeyPressed += value => currentNumpadNumber = value;
        numpad.NumpadReturned += value => returnedNumpadNumber = value;

        // Ensure the numpad is focused.
        var key = numpad.GetNode<Control>("key1");
        key.GrabFocus();
    }

    public int GetCurrentValue() => currentNumpadNumber;
    public int GetReturnedValue() => returnedNumpadNumber;
}
