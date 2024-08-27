#region Copyright
// PuzzleNumpadField.cs
// Indexing Your Heart
// 
// Created by Marquis Kurt on 11/08/2024.
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

namespace IndexingYourHeart.UI;

/// <summary>
/// A control that provides a numpad and corresponding field displaying its current value.
/// </summary>
public partial class PuzzleNumpadField : Control
{
    private Label _label;
    private AshashatNumpad _numpad;
    private AnimationPlayer _animator;

    /// <summary>
    /// The current value stored in the field.
    /// </summary>
    public int CurrentValue = 0;

    public override void _Ready()
    {
        base._Ready();
        
        _label = GetNode<Label>("VStack/PanelContainer/NumberLabel");
        _numpad = GetNode<AshashatNumpad>("VStack/Numpad");
        _animator = GetNode<AnimationPlayer>("Animator");

        _numpad.NumpadReturned += value =>
        {
            _label.Text = $"{value}";
            CurrentValue = value;
            EmitSignal(SignalName.EditingChanged, CurrentValue);
        };
    }

    /// <summary>
    /// Clear the contents of the field and reset the numpad.
    /// </summary>
    public void Clear()
    {
        CurrentValue = 0;
        _label.Text = "???";
        _animator.Stop();
        _numpad.Clear();
        _label.Modulate = Colors.White;
    }

    /// <summary>
    /// Mark the current field as the correct solution.
    /// </summary>
    public void MarkCorrect()
    {
        _animator.Stop();
        _animator.Play("correct");
    }

    /// <summary>
    /// Mark the current field as the incorrect solution.
    /// </summary>
    public void MarkIncorrect()
    {
        _animator.Stop();
        _animator.Play("incorrect");
    }

    /// <summary>
    /// Prefills the field with a specified value.
    /// </summary>
    /// <param name="newValue">The value to prefill in the field.</param>
    public void Prefill(int newValue)
    {
        CurrentValue = newValue;
        _label.Text = $"{CurrentValue}";
    }

    /// <summary>
    /// A signal emitted whenever the value in the field changes.
    /// </summary>
    [Signal]
    public delegate void EditingChangedEventHandler(int value);
}
