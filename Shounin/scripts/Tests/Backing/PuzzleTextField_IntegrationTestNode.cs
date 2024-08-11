#region Copyright
// PuzzleTextField_IntegrationTestNode.cs
// Indexing Your Heart
// 
// Created by Marquis Kurt on 10/08/2024.
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

namespace IndexingYourHeart.Tests.Backing;

public partial class PuzzleTextField_IntegrationTestNode : Control
{
    private PuzzleTextField textField;
    private string currentText;
    private string returnedText;

    public override void _Ready()
    {
        base._Ready();
        textField = GetNode<PuzzleTextField>("Puzzle Keyboard");

        textField.TextFieldChangedInput += value => { currentText = value; };
        textField.TextFieldReturned += value => { returnedText += value; };
        
        textField.GrabKeyboardFocus();
    }

    public string GetCurrentText() => currentText;
    public string GetCurrentRenderedText() => textField.GetNode<Label>("VStack/PanelContainer/TextLabel").Text;

    public string GetReturnedText() => returnedText;
}
