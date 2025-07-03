#region Copyright
// AshashatKeyboardTests.cs
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
using Godot;
using IndexingYourHeart.Ashashat;
using IndexingYourHeart.Tests.Backing;

using TestEnvironment = IndexingYourHeart.Tests.Backing.AshashatKeyboard_UnitTestNode;

namespace IndexingYourHeart.Tests.Unit;

[TestSuite]
[RequireGodotRuntime]
public class AshashatKeyboardTests
{
    [TestCase]
    public async Task TestKeyboardPressesAnyKey()
    {
        ISceneRunner keyboardRunner = ISceneRunner.Load("res://tests/scenes/keyboard_testcase.tscn");
        AssertObject(keyboardRunner).IsNotNull();
        await keyboardRunner.AwaitMillis(150);

        keyboardRunner.SimulateActionPressed("ui_accept");
        await keyboardRunner.AwaitMillis(3000);

        var keyPressed = (string)await keyboardRunner.InvokeAsync(nameof(TestEnvironment.GetLastKeyPressed));
        AssertString(keyPressed).IsEqual(AshashatKey.P.KeyCode());
    }
}
