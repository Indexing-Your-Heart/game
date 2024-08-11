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

public partial class PuzzleNumpadField : Control
{
    private Label label;
    private AshashatNumpad numpad;
    private AnimationPlayer animator;

    public int CurrentValue = 0;

    public override void _Ready()
    {
        base._Ready();
        
        label = GetNode<Label>("VStack/PanelContainer/NumberLabel");
        numpad = GetNode<AshashatNumpad>("VStack/Numpad");
        animator = GetNode<AnimationPlayer>("Animator");

        numpad.NumpadReturned += value =>
        {
            label.Text = $"{value}";
            CurrentValue = value;
            EmitSignal(SignalName.EditingChanged, CurrentValue);
        };
    }

    public void Clear()
    {
        CurrentValue = 0;
        label.Text = "???";
        animator.Stop();
        numpad.Clear();
        label.Modulate = Colors.White;
    }

    public void MarkCorrect()
    {
        animator.Stop(false);
        animator.Play("correct");
    }

    public void MarkIncorrect()
    {
        animator.Stop(false);
        animator.Play("incorrect");
    }

    public void Prefill(int newValue)
    {
        CurrentValue = newValue;
        label.Text = $"{CurrentValue}";
    }

    [Signal]
    public delegate void EditingChangedEventHandler(int value);
}
