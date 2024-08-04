#region Copyright
// KeyTextures.cs
// Indexing Your Heart
// 
// Created by Marquis Kurt on 04/08/2024.
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

namespace IndexingYourHeart.UI;

public struct KeyTextures
{
    public string Normal;
    public string Focused;
    public string Pressed;

    public void AssignStyleBoxTexturesToControl(Control control)
    {
        var normalTextureStyle = new StyleBoxTexture();
        normalTextureStyle.Texture = GD.Load<Texture2D>(Normal);
        control.Set("theme_override_styles/normal", normalTextureStyle);

        var pressedTextureStyle = new StyleBoxTexture();
        pressedTextureStyle.Texture = GD.Load<Texture2D>(Pressed);
        control.Set("theme_override_styles/pressed", pressedTextureStyle);

        var focusedTextureStyle = new StyleBoxTexture();
        focusedTextureStyle.Texture = GD.Load<Texture2D>(Focused);
        control.Set("theme_override_styles/focus", focusedTextureStyle);
    }
}
