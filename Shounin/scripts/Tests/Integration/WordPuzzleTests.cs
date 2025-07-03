#region Copyright
// WordPuzzleTests.cs
// Indexing Your Heart
// 
// Created by Marquis Kurt on 22/08/2024.
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

using TestEnvironment = IndexingYourHeart.Tests.Backing.WordPuzzle_IntegrationTestNode;

namespace IndexingYourHeart.Tests.Integration;

[TestSuite]
[RequireGodotRuntime]
public class WordPuzzleTests: IPuzzleEmbeddedTest
{
    public ISceneRunner Runner { get; set; }

    [BeforeTest]
    public async Task Setup()
    {
        this.CreateRunner("res://tests/scenes/puzzle_keyboard_testcase.tscn");
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
    public async Task TestPuzzleSolve()
    {
        await this.ApproachPuzzle();
        await Runner.InvokeAsync(nameof(TestEnvironment.GrabKeyboardFocus));

        await this.PerformActionSequence([
            "ui_right", "ui_down", "ui_down", "ui_accept", // p -> i
            "ui_right", "ui_up", "ui_up", "ui_right", "ui_accept", // i -> k
            "ui_left", "ui_down", "ui_down", "ui_accept", // k -> u,
            "ui_up", "ui_up", "ui_accept", // u -> t,
            "ui_down", "ui_accept", // t -> e,
            "ui_up", "ui_accept", // e -> t
            "ui_right", "ui_down", "ui_down", "ui_down", "ui_right", "ui_down", "ui_accept" // t -> return
        ]);

        var puzzleSolved = (bool)await Runner.InvokeAsync(nameof(TestEnvironment.PuzzleSolved));
        AssertBool(puzzleSolved).IsTrue();
    }

    [TestCase]
    public async Task TestPuzzleSolveIncorrect()
    {
        await this.ApproachPuzzle();
        await Runner.InvokeAsync(nameof(TestEnvironment.GrabKeyboardFocus));

        await this.PerformActionSequence([
            "ui_right", "ui_down", "ui_down", "ui_accept",                                  // p -> i
            "ui_right", "ui_up", "ui_up", "ui_right", "ui_accept",                          // i -> k
            "ui_left", "ui_down", "ui_down", "ui_accept",                                   // k -> u,
            "ui_up", "ui_up", "ui_accept",                                                  // u -> t,
            "ui_right", "ui_down", "ui_down", "ui_down", "ui_right", "ui_down", "ui_accept" // t -> return
        ]);

        var puzzleSolved = (bool)await Runner.InvokeAsync(nameof(TestEnvironment.PuzzleSolved));
        AssertBool(puzzleSolved).IsFalse();
    }
}
