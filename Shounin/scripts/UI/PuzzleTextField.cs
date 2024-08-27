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
    private Label _textLabel;
    private AshashatKeyboard _keyboard;
    private AnimationPlayer _animationPlayer;
    #endregion
    
    private string _currentText;
    private string _currentRenderedText;
    private readonly List<AshashatKey> _keyHistory = [];

    public override void _Ready()
    {
        base._Ready();
        _textLabel = GetNode<Label>("VStack/PanelContainer/TextLabel");
        _keyboard = GetNode<AshashatKeyboard>("VStack/HStack/Keyboard");
        _animationPlayer = GetNode<AnimationPlayer>("Animator");
        _keyboard.KeyPressed += ProcessKeyInput;
    }

    /// <summary>
    /// Clears the current field.
    /// </summary>
    public void Clear()
    {
        _currentText = "";
        _currentRenderedText = "";
        _textLabel.Text = "";
    }

    /// <summary>
    /// Ensure that the keyboard has the current input focus. The P key (i.e., the first key on the keyboard) will be the key that
    /// gains UI focus.
    /// </summary>
    /// <remarks>
    /// Typically used for UI automation tests and other accessibility calls.
    /// </remarks>
    public void GrabKeyboardFocus()
    {
        _keyboard.GetNode<Control>("Main Grid/P Key").GrabFocus();
    }
    
    /// <summary>
    /// Mark the field as the correct solution.
    /// </summary>
    public void MarkCorrect()
    {
        _animationPlayer.Stop();
        _animationPlayer.Play("correct");
    }

    /// <summary>
    /// Mark the field as the incorrect solution.
    /// </summary>
    public void MarkIncorrect()
    {
        _animationPlayer.Stop();
        _animationPlayer.Play("incorrect");
    }

    /// <summary>
    /// Prefill the text field with a value.
    /// </summary>
    /// <param name="text">The value to prefill into the text field.</param>
    public void Prefill(string text)
    {
        _currentText = text;
        
        // TODO: Make sure to transform this to a font-rendered version.
        _textLabel.Text = _currentText;
    }

    /// <summary>
    /// Stops all animations from playing on the text field.
    /// </summary>
    public void StopAnimations()
    {
        _animationPlayer.Stop();
    }

    private void ProcessKeyInput(string keyCode)
    {
        AshashatKey key = AshashatKeyUtils.KeyFromKeyCode(keyCode);
        switch (key)
        {
            case AshashatKey.Delete:
                if (_keyHistory.Count == 0)
                {
                    _currentText = "";
                    _currentRenderedText = "";
                    _textLabel.Text = "";
                    return;
                }
                AshashatKey mostRecentKey = _keyHistory.RemoveLast();
                _currentText = _currentText.TrimSuffix(mostRecentKey.KeyValue());
                _currentRenderedText = _currentRenderedText.TrimSuffix(mostRecentKey.FontRenderedValue());
                EmitSignal(SignalName.TextFieldChangedInput, _currentText);
                break;
            case AshashatKey.Return:
                EmitSignal(SignalName.TextFieldReturned, _currentText);
                break;
            default:
                _currentText += key.KeyValue();
                _currentRenderedText += key.FontRenderedValue();
                _keyHistory.Add(key);
                EmitSignal(SignalName.TextFieldChangedInput, _currentText);
                break;
        }

        _textLabel.Text = _currentRenderedText;
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
