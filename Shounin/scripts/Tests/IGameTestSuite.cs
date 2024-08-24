#region Copyright
// IGameTestSuite.cs
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

using Godot;
using GdUnit4;
using static GdUnit4.Assertions;
using System.Threading.Tasks;

namespace IndexingYourHeart.Tests;

/// <summary>
/// An interface that contains a test suite with a specified runner.
/// </summary>
public interface IGameTestSuite
{
    ISceneRunner Runner { get; set; }
}

public static class GameTestSuiteExtensions
{
    /// <summary>
    /// Create a runner that will be utilized by the test suite. This should be called in a setup method annotated with
    /// <see cref="BeforeTestAttribute"/>.
    /// </summary>
    /// <param name="testSuite">The test suite that the runner will be created for.</param>
    /// <param name="path">The path to the Godot scene that the runner will load.</param>
    public static void CreateRunner(this IGameTestSuite testSuite, string path)
    {
        testSuite.Runner = ISceneRunner.Load(path);
        AssertObject(testSuite.Runner).IsNotNull();
    }
    
    /// <summary>
    /// Perform a sequence of actions with a specified delay.
    /// </summary>
    /// <param name="testSuite">The test suite to run the action sequence in.</param>
    /// <param name="actions">The list of actions to execute.</param>
    /// <param name="delay">The number of milliseconds to wait for before starting the next action. When set to 0, the runner will
    /// wait for an idle frame instead.</param>
    public async static Task PerformActionSequence(this IGameTestSuite testSuite, string[] actions, uint delay = 0)
    {
        foreach (string action in actions)
        {
            testSuite.Runner.SimulateActionPressed(action);
            if (delay > 0)
            {
                await testSuite.Runner.AwaitMillis(delay);
            }
            else
            {
                await testSuite.Runner.AwaitIdleFrame();
            }
        }
    }
}
