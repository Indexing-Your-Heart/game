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
/// A node capable of storing numeric values represented by [ʔaʃaʃat]'s numbering system.
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
    private Button _keyOne;
    private Button _keyTwo;
    private Button _keyFour;
    private Button _keyEight;
    private Button _keySixteen;
    private Button _keyReturn;
    #endregion

    private int _currentValue = 0;

    public override void _Ready()
    {
        _keyOne = GetNode<Button>("key1");
        _keyTwo = GetNode<Button>("key2");
        _keyFour = GetNode<Button>("key4");
        _keyEight = GetNode<Button>("key8");
        _keySixteen = GetNode<Button>("key16");
        _keyReturn = GetNode<Button>("keyReturn");

        KeyTextures oneKey = GetTexturesForKey(NumpadKey.One);
        oneKey.AssignStyleBoxTexturesToControl(_keyOne);

        KeyTextures twoKey = GetTexturesForKey(NumpadKey.Two);
        twoKey.AssignStyleBoxTexturesToControl(_keyTwo);

        KeyTextures fourKey = GetTexturesForKey(NumpadKey.Four);
        fourKey.AssignStyleBoxTexturesToControl(_keyFour);

        KeyTextures eightKey = GetTexturesForKey(NumpadKey.Eight);
        eightKey.AssignStyleBoxTexturesToControl(_keyEight);

        KeyTextures sixteenKey = GetTexturesForKey(NumpadKey.Sixteen);
        sixteenKey.AssignStyleBoxTexturesToControl(_keySixteen);

        KeyTextures returnKey = GetTexturesForKey(NumpadKey.Return);
        returnKey.AssignStyleBoxTexturesToControl(_keyReturn);

        _keyOne.Pressed += delegate
        {
            _currentValue += _keyOne.ButtonPressed ? 1 : -1;
            EmitSignal(SignalName.KeyPressed, _currentValue);
        };
        
        _keyTwo.Pressed += delegate
        {
            _currentValue += _keyTwo.ButtonPressed ? 2 : -2;
            EmitSignal(SignalName.KeyPressed, _currentValue);
        };
        
        _keyFour.Pressed += delegate
        {
            _currentValue += _keyFour.ButtonPressed ? 4 : -4;
            EmitSignal(SignalName.KeyPressed, _currentValue);
        };
        
        _keyEight.Pressed += delegate
        {
            _currentValue += _keyEight.ButtonPressed ? 8 : -8;
            EmitSignal(SignalName.KeyPressed, _currentValue);
        };
        
        _keySixteen.Pressed += delegate
        {
            _currentValue += _keySixteen.ButtonPressed ? 16 : -16;
            EmitSignal(SignalName.KeyPressed, _currentValue);
        };

        _keyReturn.Pressed += () => EmitSignal(SignalName.NumpadReturned, _currentValue);
    }

    /// <summary>
    /// Clears the current input, resetting the current value to zero (0).
    /// </summary>
    public void Clear()
    {
        _currentValue = 0;
        _keyOne.ButtonPressed = false;
        _keyTwo.ButtonPressed = false;
        _keyFour.ButtonPressed = false;
        _keyEight.ButtonPressed = false;
        _keySixteen.ButtonPressed = false;
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
