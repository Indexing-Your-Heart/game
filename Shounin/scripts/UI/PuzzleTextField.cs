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

/// <summary>
/// A control that provides a text input and keyboard in the ʔaʃaʃat language.
/// </summary>
public partial class PuzzleTextField : Control
{
    #region Children
    private Label textLabel;
    private AshashatKeyboard keyboard;
    private AnimationPlayer animationPlayer;
    #endregion
    
    private string currentText;
    private string currentRenderedText;
    private readonly List<AshashatKey> keyHistory = [];

    public override void _Ready()
    {
        base._Ready();
        textLabel = GetNode<Label>("VStack/PanelContainer/TextLabel");
        keyboard = GetNode<AshashatKeyboard>("VStack/HStack/Keyboard");
        animationPlayer = GetNode<AnimationPlayer>("Animator");
        keyboard.KeyPressed += ProcessKeyInput;
    }

    public void Clear()
    {
        currentText = "";
        currentRenderedText = "";
        textLabel.Text = "";
    }

    /// <summary>
    /// Ensure that the keyboard has the current input focus.
    /// </summary>
    public void GrabKeyboardFocus()
    {
        keyboard.GetNode<Control>("Main Grid/P Key").GrabFocus();
    }

    public void MarkCorrect()
    {
        animationPlayer.Stop(false);
        animationPlayer.Play("correct");
    }

    public void MarkIncorrect()
    {
        animationPlayer.Stop(false);
        animationPlayer.Play("incorrect");
    }

    public void StopAnimations()
    {
        animationPlayer.Stop(false);
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
                EmitSignal(SignalName.TextFieldChangedInput, currentText);
                break;
            case AshashatKey.Return:
                EmitSignal(SignalName.TextFieldReturned, currentText);
                break;
            default:
                currentText += key.KeyValue();
                currentRenderedText += key.FontRenderedValue();
                keyHistory.Add(key);
                EmitSignal(SignalName.TextFieldChangedInput, currentText);
                break;
        }

        textLabel.Text = currentRenderedText;
    }

    /// <summary>
    /// A signal emitted when the text value of the text field changes, either from addition or deletion.
    /// </summary>
    [Signal]
    public delegate void TextFieldChangedInputEventHandler(string updatedText);

    /// <summary>
    /// A signal emitted when the Return key is pressed on the keyboard to indicate a final value.
    /// </summary>
    [Signal]
    public delegate void TextFieldReturnedEventHandler(string finalText);
}
