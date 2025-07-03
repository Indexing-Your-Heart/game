#region Copyright
// VirtualAshashatKeyTests.cs
// Indexing Your Heart
// 
// Created by Marquis Kurt on 31/07/2024.
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
using Godot;
using TestEnvironment = IndexingYourHeart.Tests.Backing.VirtualKeyContainer_UnitTestNode;

namespace IndexingYourHeart.Tests.Unit;

[TestSuite]
[RequireGodotRuntime]
public class VirtualAshashatKeyTests
{
    
    [TestCase]
    public async Task TestAshashatKeyPress()
    {
        
        ISceneRunner virtualKeyboard = ISceneRunner.Load("res://tests/scenes/virtualkey_testcase.tscn");
        AssertObject(virtualKeyboard).IsNotNull();

        string keyCode = (string) await virtualKeyboard.InvokeAsync(nameof(TestEnvironment.GetCurrentKeyCode));
        AssertString(keyCode).IsEqual(AshashatKey.A.KeyCode());
        
        virtualKeyboard.SimulateActionPressed("ui_accept");
        await virtualKeyboard.AwaitMillis(100);
        
        // Validates that the key was, in fact, pressed. If not, the test environment is broken, and it needs to be
        // changed so that the key grabs focus.
        bool keyWasPressed = (bool) await virtualKeyboard.InvokeAsync(nameof(TestEnvironment.GetKeyWasPressed));
        AssertBool(keyWasPressed).IsTrue();
        
        string lastKeyPressed = (string)await virtualKeyboard.InvokeAsync(nameof(TestEnvironment.GetLastKeyPressed));
        AssertString(lastKeyPressed).IsEqual(AshashatKey.A.KeyCode());
    }
}
