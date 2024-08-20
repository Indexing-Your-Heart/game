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
public class NumberPuzzleTests
{
    private ISceneRunner _runner;

    [BeforeTest]
    public void Setup()
    {
        _runner = ISceneRunner.Load("res://tests/scenes/puzzle_numpad_testcase.tscn");
    }
    
    [TestCase]
    public async Task TestPuzzleInFocus()
    {
        AssertObject(_runner).IsNotNull();
        await _runner.AwaitMillis(300);

        await ApproachPuzzle();

        var puzzleVisible = (bool)await _runner.InvokeAsync(nameof(TestEnvironment.PuzzleVisible));
        AssertBool(puzzleVisible).IsTrue();
    }

    [TestCase]
    public async Task TestPuzzleLosesFocus()
    {
        AssertObject(_runner).IsNotNull();
        await _runner.AwaitMillis(300);

        await ApproachPuzzle();
        
        // Move away from the puzzle.
        _runner.SimulateActionPress("move_left");
        await _runner.AwaitMillis(1500);
        _runner.SimulateActionRelease("move_left");
        await _runner.AwaitIdleFrame();

        var puzzleVisible = (bool)await _runner.InvokeAsync(nameof(TestEnvironment.PuzzleVisible));
        AssertBool(puzzleVisible).IsFalse();
    }

    [TestCase]
    public async Task TestPuzzleSolve()
    {
        AssertObject(_runner).IsNotNull();
        await _runner.AwaitMillis(300);
        
        await ApproachPuzzle();
        await _runner.InvokeAsync(nameof(TestEnvironment.GrabNumpadFocus));

        await SimulateActionSequence(["ui_accept", "ui_right", "ui_down", "ui_down", "ui_accept"], 150);
        
        var puzzleSolved = (bool)await _runner.InvokeAsync(nameof(TestEnvironment.PuzzleSolved));
        AssertBool(puzzleSolved).IsTrue();
    }

    [TestCase]
    public async Task TestPuzzleSolveIncorrect()
    {
        AssertObject(_runner).IsNotNull();
        await _runner.AwaitMillis(300);
        
        await ApproachPuzzle();
        await _runner.InvokeAsync(nameof(TestEnvironment.GrabNumpadFocus));

        await SimulateActionSequence(["ui_right", "ui_accept", "ui_down", "ui_down", "ui_accept"], 150);
        
        var puzzleSolved = (bool)await _runner.InvokeAsync(nameof(TestEnvironment.PuzzleSolved));
        AssertBool(puzzleSolved).IsFalse();
    }
    

    private async Task ApproachPuzzle()
    {
        // Move toward the puzzle.
        _runner.SimulateActionPress("move_right");
        await _runner.AwaitMillis(1500);
        _runner.SimulateActionRelease("move_right");
        await _runner.AwaitIdleFrame();
        
        // Trigger the puzzle UI to appear, if we're in range.
        _runner.SimulateActionPressed("interact");
        await _runner.AwaitIdleFrame();
    }

    private async Task SimulateActionSequence(string[] actions, uint delay = 0)
    {
        foreach (string action in actions)
        {
            _runner.SimulateActionPressed(action);
            if (delay > 0)
            {
                await _runner.AwaitMillis(delay);
            }
            else
            {
                await _runner.AwaitIdleFrame();
            }
        }
    }
}
