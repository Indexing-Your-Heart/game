#region Copyright
// AshashatNumpad.cs
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
using IndexingYourHeart.UI;

namespace IndexingYourHeart.Ashashat;

/// <summary>
/// A node capable of storing numeric values represented by ʔaʃaʃat's numbering system.
/// </summary>
public partial class AshashatNumpad : Control
{
    /// <summary>
    /// An enumeration representing the various keys in the numpad.
    /// </summary>
    public enum NumpadKey
    {
        One, Two, Four, Eight, Sixteen, Return
    }
    
    #region Children
    private Button KeyOne;
    private Button KeyTwo;
    private Button KeyFour;
    private Button KeyEight;
    private Button KeySixteen;
    private Button KeyReturn;
    #endregion

    private int currentValue = 0;

    public override void _Ready()
    {
        KeyOne = GetNode<Button>("key1");
        KeyTwo = GetNode<Button>("key2");
        KeyFour = GetNode<Button>("key4");
        KeyEight = GetNode<Button>("key8");
        KeySixteen = GetNode<Button>("key16");
        KeyReturn = GetNode<Button>("keyReturn");

        KeyTextures oneKey = GetTexturesForKey(NumpadKey.One);
        oneKey.AssignStyleBoxTexturesToControl(KeyOne);

        KeyTextures twoKey = GetTexturesForKey(NumpadKey.Two);
        twoKey.AssignStyleBoxTexturesToControl(KeyTwo);

        KeyTextures fourKey = GetTexturesForKey(NumpadKey.Four);
        fourKey.AssignStyleBoxTexturesToControl(KeyFour);

        KeyTextures eightKey = GetTexturesForKey(NumpadKey.Eight);
        eightKey.AssignStyleBoxTexturesToControl(KeyEight);

        KeyTextures sixteenKey = GetTexturesForKey(NumpadKey.Sixteen);
        sixteenKey.AssignStyleBoxTexturesToControl(KeySixteen);

        KeyTextures returnKey = GetTexturesForKey(NumpadKey.Return);
        returnKey.AssignStyleBoxTexturesToControl(KeyReturn);

        KeyOne.Pressed += delegate
        {
            currentValue += KeyOne.ButtonPressed ? 1 : -1;
            EmitSignal(SignalName.KeyPressed, currentValue);
        };
        
        KeyTwo.Pressed += delegate
        {
            currentValue += KeyTwo.ButtonPressed ? 2 : -2;
            EmitSignal(SignalName.KeyPressed, currentValue);
        };
        
        KeyFour.Pressed += delegate
        {
            currentValue += KeyFour.ButtonPressed ? 4 : -4;
            EmitSignal(SignalName.KeyPressed, currentValue);
        };
        
        KeyEight.Pressed += delegate
        {
            currentValue += KeyEight.ButtonPressed ? 8 : -8;
            EmitSignal(SignalName.KeyPressed, currentValue);
        };
        
        KeySixteen.Pressed += delegate
        {
            currentValue += KeySixteen.ButtonPressed ? 16 : -16;
            EmitSignal(SignalName.KeyPressed, currentValue);
        };

        KeyReturn.Pressed += () => EmitSignal(SignalName.NumpadReturned, currentValue);
    }

    private static KeyTextures GetTexturesForKey(NumpadKey key)
    {
        string textureName = GetTextureNameForKey(key);
        return key switch
        {
            NumpadKey.Return => new KeyTextures
            {
                Normal = "res://resources/gui/keyboard/Return_Normal.png",
                Focused = "res://resources/gui/keyboard/Return_Focus.png",
                Pressed = "res://resources/gui/keyboard/Return_Press.png"
            },
            _ => new KeyTextures
            {
                Normal = $"res://resources/gui/numpad/{textureName}_Normal.png",
                Focused = $"res://resources/gui/numpad/{textureName}_Focus.png",
                Pressed = $"res://resources/gui/numpad/Number_Active_Press.png"
            }
        };
    }

    private static KeyTextures GetActiveKeyTextures() => new KeyTextures
    {
        Normal = "res://resources/gui/numpad/Number_Active_Normal.png",
        Focused = "res://resources/gui/numpad/Number_Active_Focus.png",
        Pressed = "res://resources/gui/numpad/Number_Active_Press.png"
    };

    private static string GetTextureNameForKey(NumpadKey key) => key switch
    {
        NumpadKey.One => "Number_Straight",
        NumpadKey.Two or NumpadKey.Eight => "Number_Slash",
        NumpadKey.Four or NumpadKey.Sixteen => "Number_Backslash",
        NumpadKey.Return => "Return"
    };

    /// <summary>
    /// A signal emitted when a key is pressed on the numpad.
    /// </summary>
    [Signal]
    public delegate void KeyPressedEventHandler(int currentValue);

    /// <summary>
    /// A signal emitted when the Return key is pressed on the numpad. Readers should leverage this value as it
    /// represents the final value, rather than the currently present value.
    /// </summary>
    [Signal]
    public delegate void NumpadReturnedEventHandler(int finalValue);
}
