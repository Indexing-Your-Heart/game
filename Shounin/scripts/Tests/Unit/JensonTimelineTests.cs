#region Copyright
//
//  JensonTimelineTests.cs
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 23/7/2024.
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

namespace IndexingYourHeart.Tests.Unit
{
    [TestSuite]
    [RequireGodotRuntime]
    public class JensonTimelineTests
    {
        [TestCase]
        public void Test_JensonTimelineInitialState()
        {
            var timeline = AutoFree(new JensonTimeline());
            AssertObject(timeline).IsNotNull();
            AssertThat(timeline!.CurrentTimelineState).IsEqual(JensonTimeline.TimelineState.Initial);
        }

        [TestCase]
        public void Test_JensonTimelineLoads()
        {
            var timeline = AutoFree(new JensonTimeline());
            AssertObject(timeline).IsNotNull();
            timeline!.Script = "res://data/test_scpt_v3.jenson";
            timeline!.LoadScript();

            AssertThat(timeline.CurrentTimelineState).IsEqual(JensonTimeline.TimelineState.Loaded);
        }
    }
}
