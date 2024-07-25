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

using Godot;
using GdUnit4;
using static GdUnit4.Assertions;
using IndexingYourHeart.UI;
using System.Threading.Tasks;
using GdUnit4.Asserts;

namespace IndexingYourHeart.Tests.Integration
{
    [TestSuite]
    public class JensonTimeline_IntegrationTests
    {
        [TestCase]
        public void Test_SceneLoads_EntersStartedState()
        {
            ISceneRunner runner = ISceneRunner.Load("res://tests/scenes/jenson_testcase.tscn");
            AssertObject(runner).IsNotNull();

            var timelineState = (int)runner.Invoke("GetTimelineState");
            AssertInt(timelineState).MatchesTimelineState(JensonTimeline.TimelineState.Started);
        }     
    }

    static class JensonTimeline_IntegrationTests_Extensions
    {
        public static IAssertBase<int> MatchesTimelineState(this INumberAssert<int> assert, JensonTimeline.TimelineState timelineState)
        {
            return assert.IsEqual((int)timelineState);
        }
    }
}
