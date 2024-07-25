#region Copyright
//
//  JensonTimeline_IntegrationTestNode.cs
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
using IndexingYourHeart.UI;

namespace IndexingYourHeart.Tests.Backing
{
    public partial class JensonTimeline_IntegrationTestNode : CanvasLayer
    {
        public JensonTimeline Timeline;

        public override void _Ready()
        {
            Timeline = GetNode<JensonTimeline>("JensonTimeline");
            Timeline.TimelineLoaded += delegate
            {
                EmitSignal(SignalName.JensonTimeline_Loaded_);
            };

            Timeline.TimelineFinished += delegate
            {
                GetTree().Quit();
            };
        }

        public JensonTimeline.TimelineState GetTimelineState()
        {
            return Timeline.CurrentTimelineState;
        }

        [Signal]
        public delegate void JensonTimeline_Loaded_EventHandler();
    }
}
