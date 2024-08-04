#region Copyright
// PuzzleTextField.cs
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
using IndexingYourHeart.Ashashat;
using System.Collections.Generic;
using IndexingYourHeart.Utils;

namespace IndexingYourHeart.UI;

// TODO: Write unit tests for this!

public partial class PuzzleTextField : Control
{
    #region Children
    private Label textLabel;
    private AshashatKeyboard keyboard;
    #endregion
    
    private string currentText;
    private string currentRenderedText;
    private readonly List<AshashatKey> keyHistory = [];

    public override void _Ready()
    {
        base._Ready();
        textLabel = GetNode<Label>("VStack/PanelContainer/TextLabel");
        keyboard = GetNode<AshashatKeyboard>("VStack/HStack/Keyboard");
        keyboard.KeyPressed += ProcessKeyInput;
    }

    private void ProcessKeyInput(string keyCode)
    {
        AshashatKey key = AshashatKeyUtils.KeyFromKeyCode(keyCode);
        switch (key)
        {
            case AshashatKey.Delete:
                if (keyHistory.Count == 0)
                {
                    currentText = "";
                    currentRenderedText = "";
                    textLabel.Text = "";
                    return;
                }
                AshashatKey mostRecentKey = keyHistory.RemoveLast();
                currentText = currentText.TrimSuffix(mostRecentKey.KeyValue());
                currentRenderedText = currentRenderedText.TrimSuffix(mostRecentKey.FontRenderedValue());
                break;
            case AshashatKey.Return:
                EmitSignal(SignalName.TextFieldReturned, currentText);
                break;
            default:
                currentText += key.KeyValue();
                currentRenderedText += key.FontRenderedValue();
                keyHistory.Add(key);
                break;
        }

        textLabel.Text = currentRenderedText;
    }

    [Signal]
    public delegate void TextFieldReturnedEventHandler(string finalText);
}
