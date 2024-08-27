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
using IndexingYourHeart.UI;

namespace IndexingYourHeart.Ashashat;

/// <summary>
/// A control that represents an individual key on the ʔaʃaʃat keyboard.
/// </summary>
[Tool]
public partial class VirtualAshashatKey : Button
{
    /// <summary>
    /// The key value this control represents.
    /// </summary>
    [Export]
    public AshashatKey Key
    {
        get => _key;
        set
        {
            _key = value;
            AssignKeyTextures();
        }
    }

    private AshashatKey _key = AshashatKey.Delete;

    public override void _Ready()
    {
        base._Ready();
        Pressed += () => EmitSignal(SignalName.KeyPressed, Key.KeyCode());
    }

    private void AssignKeyTextures()
    {
        // Don't assign textures or adjust sizes when in tool mode, to prevent constant changes to scenes that rely on it.
        if (Engine.IsEditorHint()) return;
        
        KeyTextures keyTextures = TextureForCurrentKey();
        keyTextures.AssignStyleBoxTexturesToControl(this);

        Size = SizeForCurrentKey();
        CustomMinimumSize = SizeForCurrentKey();
    }

    private Vector2 SizeForCurrentKey() => _key switch
    {
        AshashatKey.Delete or AshashatKey.Return => new Vector2(160, 112),
        _ => new Vector2(112, 112)
    };

    private KeyTextures TextureForCurrentKey()
    {
        string keyValue = _key switch
        {
            AshashatKey.Glottal => "Glottal",
            AshashatKey.Sh => "Sh",
            AshashatKey.EjectiveK => "Ejective_K",
            AshashatKey.Duplicant => "Duplicant",
            AshashatKey.Repeater => "Repeater",
            AshashatKey.Delete => "Delete",
            AshashatKey.Return => "Return",
            _ => _key.KeyValue().ToUpper()
        };
        
        return new KeyTextures
        {
            Normal = $"res://resources/gui/keyboard/{keyValue}_Normal.png",
            Focused = $"res://resources/gui/keyboard/{keyValue}_Focus.png",
            Pressed =  $"res://resources/gui/keyboard/{keyValue}_Press.png"
        };
    }

    /// <summary>
    /// A signal emitted when this key is pressed.
    /// </summary>
    [Signal]
    public delegate void KeyPressedEventHandler(string keyCode);
}
