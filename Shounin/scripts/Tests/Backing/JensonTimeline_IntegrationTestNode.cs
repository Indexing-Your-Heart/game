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
        private JensonTimeline Timeline;
        private string[] dialogue;

        public override void _Ready()
        {
            Timeline = GetNode<JensonTimeline>("JensonTimeline");
            Timeline.TimelineDialogueFired += (Who, What) =>
            {
                GD.Print("Wow!");
                dialogue = [Who, What];
            };
        }

        public JensonTimeline.TimelineState GetTimelineState()
        {
            return Timeline.CurrentTimelineState;
        }

        public string[] GetTimelineDialogue()
        {
            return dialogue;
        }
    }
}
