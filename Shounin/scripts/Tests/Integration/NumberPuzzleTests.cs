#region Copyright
// NumberPuzzleTests.cs
// Indexing Your Heart
// 
// Created by Marquis Kurt on 19/08/2024.
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

using TestEnvironment = IndexingYourHeart.Tests.Backing.NumberPuzzle_IntegrationTestNode;

namespace IndexingYourHeart.Tests.Integration;

[TestSuite]
public class NumberPuzzleTests: IPuzzleEmbeddedTest
{
    public ISceneRunner Runner { get; set; }

    [BeforeTest]
    public async Task Setup()
    {
        this.CreateRunner("res://tests/scenes/puzzle_numpad_testcase.tscn");
        await Runner.AwaitMillis(300);
    }
    
    [TestCase]
    public async Task TestPuzzleInFocus()
    {
        await this.ApproachPuzzle();

        var puzzleVisible = (bool)await Runner.InvokeAsync(nameof(TestEnvironment.PuzzleVisible));
        AssertBool(puzzleVisible).IsTrue();
    }

    [TestCase]
    public async Task TestPuzzleLosesFocus()
    {
        await this.ApproachPuzzle();
        
        // Move away from the puzzle.
        Runner.SimulateActionPress("move_left");
        await Runner.AwaitMillis(1500);
        Runner.SimulateActionRelease("move_left");
        await Runner.AwaitIdleFrame();

        var puzzleVisible = (bool)await Runner.InvokeAsync(nameof(TestEnvironment.PuzzleVisible));
        AssertBool(puzzleVisible).IsFalse();
    }

    [TestCase]
    public async Task TestPuzzleSolve()
    {
        await this.ApproachPuzzle();
        await Runner.InvokeAsync(nameof(TestEnvironment.GrabNumpadFocus));

        await this.PerformActionSequence(["ui_accept", "ui_right", "ui_down", "ui_down", "ui_accept"], 150);
        
        var puzzleSolved = (bool)await Runner.InvokeAsync(nameof(TestEnvironment.PuzzleSolved));
        AssertBool(puzzleSolved).IsTrue();
    }

    [TestCase]
    public async Task TestPuzzleSolveIncorrect()
    {
        await this.ApproachPuzzle();
        await Runner.InvokeAsync(nameof(TestEnvironment.GrabNumpadFocus));

        await this.PerformActionSequence(["ui_right", "ui_accept", "ui_down", "ui_down", "ui_accept"], 150);
        
        var puzzleSolved = (bool)await Runner.InvokeAsync(nameof(TestEnvironment.PuzzleSolved));
        AssertBool(puzzleSolved).IsFalse();
    }
}
