#region Copyright
// IPuzzleEmbeddedTest.cs
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
using System.Threading.Tasks;

namespace IndexingYourHeart.Tests;

/// <summary>
/// An interface for test suites that have an embedded puzzle in them.
/// </summary>
public interface IPuzzleEmbeddedTest: IGameTestSuite
{
    
}

public static class PuzzleEmbeddedTestExtensions
{
    /// <summary>
    /// Approach the puzzle in the test environment.
    /// </summary>
    /// <remarks>
    /// The environment assumes that the puzzle is on the player's right, and that it takes about 1.5 seconds to reach the target.
    /// Interaction is done automatically.
    /// </remarks>
    /// <param name="testSuite">The test suite to run the simulation in.</param>
    public async static Task ApproachPuzzle(this IPuzzleEmbeddedTest testSuite)
    {
        // Move toward the puzzle.
        testSuite.Runner.SimulateActionPress("move_right");
        await testSuite.Runner.AwaitMillis(1500);
        testSuite.Runner.SimulateActionRelease("move_right");
        await testSuite.Runner.AwaitIdleFrame();
        
        // Trigger the puzzle UI to appear, if we're in range.
        testSuite.Runner.SimulateActionPressed("interact");
        await testSuite.Runner.AwaitIdleFrame();
    }
}
