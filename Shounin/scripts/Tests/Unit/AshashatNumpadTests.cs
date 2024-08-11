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
public class AshashatNumpadTests
{
    private ISceneRunner numpadRunner;

    [BeforeTest]
    public void Setup()
    {
        numpadRunner = ISceneRunner.Load("res://tests/scenes/numpad_testcase.tscn");
    }
    
    [TestCase]
    public async Task TestNumpadPressesKey()
    {
        AssertObject(numpadRunner).IsNotNull();
        await numpadRunner.AwaitMillis(150);

        await PressActiveKey();

        var currentValue = (int)await numpadRunner.InvokeAsync(nameof(TestEnvironment.GetCurrentValue));
        AssertInt(currentValue).IsEqual(1);
    }

    [TestCase]
    public async Task TestNumpadToggle()
    {
        AssertObject(numpadRunner).IsNotNull();
        await numpadRunner.AwaitMillis(150);

        await PressActiveKey();
        
        numpadRunner.SimulateActionPressed("ui_focus_next");
        await numpadRunner.SimulateFrames(10);

        await PressActiveKey();
        
        var initialValue = (int)await numpadRunner.InvokeAsync(nameof(TestEnvironment.GetCurrentValue));
        AssertInt(initialValue).IsEqual(3);
        
        // NOTE: Pressing the key again should "turn off" the corresponding bit in the number string.
        numpadRunner.SimulateActionPressed("ui_accept");
        await numpadRunner.SimulateFrames(10);
        
        var nextValue = (int)await numpadRunner.InvokeAsync(nameof(TestEnvironment.GetCurrentValue));
        AssertInt(nextValue).IsEqual(1);
    }

    [TestCase]
    public async Task TestNumpadReturns()
    {
        AssertObject(numpadRunner).IsNotNull();
        await numpadRunner.AwaitMillis(150);

        await PressActiveKey();

        // Cycle to get to the return key.
        for (var i = 0; i < 5; i++)
        {
            numpadRunner.SimulateActionPressed("ui_focus_next");
            await numpadRunner.SimulateFrames(10);
        }

        await PressActiveKey();
        var returnedValue = (int)await numpadRunner.InvokeAsync(nameof(TestEnvironment.GetReturnedValue));
        AssertInt(returnedValue).IsEqual(1);
    }

    private async Task PressActiveKey()
    {
        numpadRunner.SimulateActionPressed("ui_accept");
        await numpadRunner.SimulateFrames(10);
    }
}
