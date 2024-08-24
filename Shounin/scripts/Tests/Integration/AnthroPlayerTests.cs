#region Copyright
//
// AnthroPlayerTests.cs
// Indexing Your Heart
//
// Created by Marquis Kurt on 28/07/2024.
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
using IndexingYourHeart.Tests.Backing;

namespace IndexingYourHeart.Tests.Integration;

[TestSuite]
public class AnthroPlayerTests : IGameTestSuite
{
    public ISceneRunner Runner { get; set; }

    [BeforeTest]
    public void Setup()
    {
        this.CreateRunner("res://tests/scenes/environment_testcase.tscn");
    }
    
    [TestCase]
    public async Task TestPlayerMovement()
    {
        Vector2 origin = GetPlayerVector();
        AssertThat(origin).IsNotNull();
        await Runner.AwaitMillis(2000);

        Runner.SimulateKeyPress(Key.A);
        await Runner.SimulateFrames(20);
        Runner.SimulateKeyRelease(Key.A);
        
        Vector2 newPosition = GetPlayerVector();
        AssertThat(newPosition).IsNotNull();
        AssertThat(newPosition).IsNotEqual(origin);
    }

    private Vector2 GetPlayerVector()
    {
        float xPosition = (float)Runner.Invoke(nameof(AnthroPlayer_IntegrationTestNode.GetPlayerPositionX));
        float yPosition = (float)Runner.Invoke(nameof(AnthroPlayer_IntegrationTestNode.GetPlayerPositionY));
        
        return new Vector2(xPosition, yPosition);
    }
}
