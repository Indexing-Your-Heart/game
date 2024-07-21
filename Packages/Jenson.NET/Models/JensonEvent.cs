#region Copyright
//
//  JensonEvent.cs
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 21/7/2024.
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

namespace Jenson.NET.Models
{
    public enum JensonEventType
    {
        Narration,
        Dialogue,
        Refresh,
        Question,
        Choice
    }

    public interface IJensonEvent
    {
        public JensonEventType EventType { get; }
    }

    public record DialogueEvent(string Who, string What): IJensonEvent
    {
        public JensonEventType EventType => JensonEventType.Dialogue;
    }

    public record NarrationEvent(string What) : IJensonEvent
    {
        public JensonEventType EventType => JensonEventType.Narration;
    }

    public record RefreshEvent(string What, string Kind, int Priority = 0) : IJensonEvent
    {
        public JensonEventType EventType => JensonEventType.Refresh;
    }

    public record QuestionEvent(string What, ChoiceEvent[] Choices, string Who=""): IJensonEvent
    {
        public JensonEventType EventType => JensonEventType.Question;
    }

    public record ChoiceEvent(string What, IJensonEvent[] Events): IJensonEvent
    {
        public JensonEventType EventType => JensonEventType.Choice;
    }
}
