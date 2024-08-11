#region Copyright
// PuzzleTextFieldTests.cs
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

using GdUnit4;
using static GdUnit4.Assertions;
using System.Threading.Tasks;

using TestEnvironment = IndexingYourHeart.Tests.Backing.PuzzleTextField_IntegrationTestNode;

namespace IndexingYourHeart.Tests.Integration;

[TestSuite]
public class PuzzleTextFieldTests
{
    private ISceneRunner textFieldRunner;

    [BeforeTest]
    public void Setup()
    {
        textFieldRunner = ISceneRunner.Load("res://tests/scenes/textfield_testcase.tscn");
    }
    
    [TestCase]
    public async Task TestKeyboardPressChangesInput()
    {
        AssertObject(textFieldRunner).IsNotNull();
        await textFieldRunner.AwaitMillis(150);

        await PressActiveKey();

        var currentText = (string)await textFieldRunner.InvokeAsync(nameof(TestEnvironment.GetCurrentText));
        AssertString(currentText).IsEqual("p");
    }

    [TestCase]
    public async Task TestKeyboardProcessesFullInput()
    {
        AssertObject(textFieldRunner).IsNotNull();
        await textFieldRunner.AwaitMillis(150);

        await TypeAshashatWord();
        
        var currentText = (string)await textFieldRunner.InvokeAsync(nameof(TestEnvironment.GetCurrentText));
        AssertString(currentText).Equals("ʔaʃaʃat");

        // Rendered text should differ slightly to the current text value.
        var renderedText = (string)await textFieldRunner.InvokeAsync(nameof(TestEnvironment.GetCurrentRenderedText));
        AssertString(renderedText).Equals("ʔashashat");
    }

    [TestCase]
    public async Task TestKeyboardDeletions()
    {
        AssertObject(textFieldRunner).IsNotNull();
        await textFieldRunner.AwaitMillis(150);

        await TypeAshashatWord(navigateToDelete: true);
        await PressActiveKey();
        
        var currentText = (string)await textFieldRunner.InvokeAsync(nameof(TestEnvironment.GetCurrentText));
        var renderedText = (string)await textFieldRunner.InvokeAsync(nameof(TestEnvironment.GetCurrentRenderedText));
        AssertString(currentText).Equals("ʔaʃaʃa");
        AssertString(renderedText).Equals("ʔashasha");

        await PressActiveKey();
        currentText = (string)await textFieldRunner.InvokeAsync(nameof(TestEnvironment.GetCurrentText));
        renderedText = (string)await textFieldRunner.InvokeAsync(nameof(TestEnvironment.GetCurrentRenderedText));
        AssertString(currentText).Equals("ʔaʃaʃ");
        AssertString(renderedText).Equals("ʔashash");
        
        // Verify double-wide characters are deleted correctly for font-rendered values.
        await PressActiveKey();
        currentText = (string)await textFieldRunner.InvokeAsync(nameof(TestEnvironment.GetCurrentText));
        renderedText = (string)await textFieldRunner.InvokeAsync(nameof(TestEnvironment.GetCurrentRenderedText));
        AssertString(currentText).Equals("ʔaʃa");
        AssertString(renderedText).Equals("ʔasha");
    }

    private async Task TypeAshashatWord(bool navigateToDelete = false)
    {
        // Type "?ashashat".
        await RunActionSequence(["ui_right", "ui_right", "ui_right", "ui_down", "ui_accept"]);  // p -> glottal
        await RunActionSequence(["ui_left", "ui_left", "ui_accept"]);                           // glottal -> a
        await RunActionSequence(["ui_down", "ui_right", "ui_right", "ui_accept"]);              // a -> sh
        await RunActionSequence(["ui_left", "ui_left", "ui_up", "ui_accept"]);                  // sh -> a
        await RunActionSequence(["ui_down", "ui_right", "ui_right", "ui_accept"]);              // a -> sh
        await RunActionSequence(["ui_left", "ui_left", "ui_up", "ui_accept"]);                  // sh -> a
        await RunActionSequence(["ui_up", "ui_right", "ui_accept"]);                            // a -> t

        if (navigateToDelete)
            await RunActionSequence(["ui_down", "ui_down", "ui_right", "ui_down", "ui_down"]);
    }

    private async Task RunActionSequence(string[] sequence)
    {
        foreach (var action in sequence)
        {
            await RunAction(action);
        }
    }

    private async Task RunAction(string actionName)
    {
        textFieldRunner.SimulateActionPressed(actionName);
        await textFieldRunner.SimulateFrames(10);
    }

    private async Task PressActiveKey()
    {
        textFieldRunner.SimulateActionPressed("ui_accept");
        await textFieldRunner.SimulateFrames(10);
    }
}
