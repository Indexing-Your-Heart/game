#region Copyright
// AshashatNumpadTests.cs
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
using IndexingYourHeart.Ashashat;
using System.Threading.Tasks;

using TestEnvironment = IndexingYourHeart.Tests.Backing.AshashatNumpad_UnitTestNode;

namespace IndexingYourHeart.Tests.Unit;

[TestSuite]
[RequireGodotRuntime]
public class AshashatNumpadTests : IGameTestSuite
{
    public ISceneRunner Runner { get; set; }

    [BeforeTest]
    public async Task Setup()
    {
        this.CreateRunner("res://tests/scenes/numpad_testcase.tscn");
        await Runner.AwaitMillis(150);
    }
    
    [TestCase]
    public async Task TestNumpadPressesKey()
    {
        await PressActiveKey();

        var currentValue = (int)await Runner.InvokeAsync(nameof(TestEnvironment.GetCurrentValue));
        AssertInt(currentValue).IsEqual(1);
    }

    [TestCase]
    public async Task TestNumpadToggle()
    {
        await PressActiveKey();
        
        Runner.SimulateActionPressed("ui_focus_next");
        await Runner.SimulateFrames(10);

        await PressActiveKey();
        
        var initialValue = (int)await Runner.InvokeAsync(nameof(TestEnvironment.GetCurrentValue));
        AssertInt(initialValue).IsEqual(3);
        
        // NOTE: Pressing the key again should "turn off" the corresponding bit in the number string.
        Runner.SimulateActionPressed("ui_accept");
        await Runner.SimulateFrames(10);
        
        var nextValue = (int)await Runner.InvokeAsync(nameof(TestEnvironment.GetCurrentValue));
        AssertInt(nextValue).IsEqual(1);
    }

    [TestCase]
    public async Task TestNumpadReturns()
    {
        await PressActiveKey();

        // Cycle to get to the return key.
        for (var i = 0; i < 5; i++)
        {
            Runner.SimulateActionPressed("ui_focus_next");
            await Runner.SimulateFrames(10);
        }

        await PressActiveKey();
        var returnedValue = (int)await Runner.InvokeAsync(nameof(TestEnvironment.GetReturnedValue));
        AssertInt(returnedValue).IsEqual(1);
    }

    private async Task PressActiveKey()
    {
        Runner.SimulateActionPressed("ui_accept");
        await Runner.SimulateFrames(10);
    }
}
