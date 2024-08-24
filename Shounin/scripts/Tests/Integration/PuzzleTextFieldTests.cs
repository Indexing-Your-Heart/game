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
public class PuzzleTextFieldTests : IGameTestSuite
{
    public ISceneRunner Runner { get; set; }

    [BeforeTest]
    public async Task Setup()
    {
        this.CreateRunner("res://tests/scenes/textfield_testcase.tscn");
        await Runner.AwaitMillis(150);
    }
    
    [TestCase]
    public async Task TestKeyboardPressChangesInput()
    {
        await PressActiveKey();

        var currentText = (string)await Runner.InvokeAsync(nameof(TestEnvironment.GetCurrentText));
        AssertString(currentText).IsEqual("p");
    }

    [TestCase]
    public async Task TestKeyboardProcessesFullInput()
    {
        await TypeAshashatWord();
        
        var currentText = (string)await Runner.InvokeAsync(nameof(TestEnvironment.GetCurrentText));
        AssertString(currentText).Equals("ʔaʃaʃat");

        // Rendered text should differ slightly to the current text value.
        var renderedText = (string)await Runner.InvokeAsync(nameof(TestEnvironment.GetCurrentRenderedText));
        AssertString(renderedText).Equals("ʔashashat");
    }

    [TestCase]
    public async Task TestKeyboardDeletions()
    {
        

        await TypeAshashatWord(navigateToDelete: true);
        await PressActiveKey();
        
        var currentText = (string)await Runner.InvokeAsync(nameof(TestEnvironment.GetCurrentText));
        var renderedText = (string)await Runner.InvokeAsync(nameof(TestEnvironment.GetCurrentRenderedText));
        AssertString(currentText).Equals("ʔaʃaʃa");
        AssertString(renderedText).Equals("ʔashasha");

        await PressActiveKey();
        currentText = (string)await Runner.InvokeAsync(nameof(TestEnvironment.GetCurrentText));
        renderedText = (string)await Runner.InvokeAsync(nameof(TestEnvironment.GetCurrentRenderedText));
        AssertString(currentText).Equals("ʔaʃaʃ");
        AssertString(renderedText).Equals("ʔashash");
        
        // Verify double-wide characters are deleted correctly for font-rendered values.
        await PressActiveKey();
        currentText = (string)await Runner.InvokeAsync(nameof(TestEnvironment.GetCurrentText));
        renderedText = (string)await Runner.InvokeAsync(nameof(TestEnvironment.GetCurrentRenderedText));
        AssertString(currentText).Equals("ʔaʃa");
        AssertString(renderedText).Equals("ʔasha");
    }

    private async Task TypeAshashatWord(bool navigateToDelete = false)
    {
        // Type "?ashashat".
        await this.PerformActionSequence(["ui_right", "ui_right", "ui_right", "ui_down", "ui_accept"]);  // p -> glottal
        await this.PerformActionSequence(["ui_left", "ui_left", "ui_accept"]);                           // glottal -> a
        await this.PerformActionSequence(["ui_down", "ui_right", "ui_right", "ui_accept"]);              // a -> sh
        await this.PerformActionSequence(["ui_left", "ui_left", "ui_up", "ui_accept"]);                  // sh -> a
        await this.PerformActionSequence(["ui_down", "ui_right", "ui_right", "ui_accept"]);              // a -> sh
        await this.PerformActionSequence(["ui_left", "ui_left", "ui_up", "ui_accept"]);                  // sh -> a
        await this.PerformActionSequence(["ui_up", "ui_right", "ui_accept"]);                            // a -> t

        if (navigateToDelete)
            await this.PerformActionSequence(["ui_down", "ui_down", "ui_right", "ui_down", "ui_down"]);
    }

    private async Task PressActiveKey()
    {
        Runner.SimulateActionPressed("ui_accept");
        await Runner.SimulateFrames(10);
    }
}
