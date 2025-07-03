#region Copyright

//
//  JensonTimelineTests.cs
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 24/7/2024.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

#endregion

using GdUnit4;
using static GdUnit4.Assertions;
using IndexingYourHeart.UI;
using System.Threading.Tasks;
using GdUnit4.Asserts;

namespace IndexingYourHeart.Tests.Integration;

[TestSuite]
[RequireGodotRuntime]
public class JensonTimelineTests : IGameTestSuite
{
    public ISceneRunner Runner { get; set; }

    [Before]
    public void Setup()
    {
        this.CreateRunner("res://tests/scenes/jenson_testcase.tscn");
    }
    
    [TestCase]
    public void Test_SceneLoads_EntersStartedState()
    {
        var timelineState = (int)Runner.Invoke("GetTimelineState");
        AssertInt(timelineState).MatchesTimelineState(JensonTimeline.TimelineState.Started);
    }

    [TestCase]
    public async Task Test_SceneLoads_EntersPlayingState()
    {
        await Runner.AwaitMillis(1500); // Ensure first scene plays.

        var timelineState = (int)await Runner.InvokeAsync("GetTimelineState");
        AssertInt(timelineState).MatchesTimelineState(JensonTimeline.TimelineState.Playing);

        var timelineDialogue = (string[])await Runner.InvokeAsync("GetTimelineDialogue");
        AssertThat(timelineDialogue).IsEqual(["<#narration#>", "I am narrating the current story."]);
    }

    [TestCase]
    public async Task Test_SceneAdvances()
    {
        await Runner.AwaitMillis(3000); // Increased time to let dialogue pan out.

        Runner.SimulateActionPressed("timeline_next");
        await Runner.AwaitIdleFrame();

        var timelineDialogue = (string[])await Runner.InvokeAsync("GetTimelineDialogue");
        AssertThat(timelineDialogue).IsEqual(["Amy", "Who are you talking to?"]);
    }
}

static class JensonTimeline_IntegrationTests_Extensions
{
    public static IAssertBase<int> MatchesTimelineState(this INumberAssert<int> assert,
        JensonTimeline.TimelineState timelineState)
    {
        return assert.IsEqual((int)timelineState);
    }
}
