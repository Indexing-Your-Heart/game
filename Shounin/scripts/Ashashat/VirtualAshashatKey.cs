#region Copyright
// VirtualAshashatKey.cs
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

namespace IndexingYourHeart.Ashashat;

public partial class VirtualAshashatKey : Button
{
    [Export]
    public AshashatKey Key = AshashatKey.Delete;

    public override void _Ready()
    {
        base._Ready();
        Pressed += () => EmitSignal(SignalName.KeyPressed, Key.KeyCode());
    }

    [Signal]
    public delegate void KeyPressedEventHandler(string keyCode);
}
