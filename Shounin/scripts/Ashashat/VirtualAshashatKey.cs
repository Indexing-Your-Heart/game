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

[Tool]
public partial class VirtualAshashatKey : Button
{
    internal struct KeyTextures
    {
        internal string Normal;
        internal string Pressed;
        internal string Focused;
    }
    
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
        var keyTextures = TextureForCurrentKey();
        
        var normalTextureStyle = new StyleBoxTexture();
        normalTextureStyle.Texture = GD.Load<Texture2D>(keyTextures.Normal);
        Set("theme_override_styles/normal", normalTextureStyle);

        var pressedTextureStyle = new StyleBoxTexture();
        pressedTextureStyle.Texture = GD.Load<Texture2D>(keyTextures.Pressed);
        Set("theme_override_styles/pressed", pressedTextureStyle);

        var focusedTextureStyle = new StyleBoxTexture();
        focusedTextureStyle.Texture = GD.Load<Texture2D>(keyTextures.Focused);
        Set("theme_override_styles/focus", focusedTextureStyle);
        Set("theme_override_styles/hover", focusedTextureStyle);

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

    [Signal]
    public delegate void KeyPressedEventHandler(string keyCode);
}
