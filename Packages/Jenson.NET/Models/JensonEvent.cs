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

namespace Jenson.NET.Models;

/// <summary>
/// An enumeration for the different event types in a Jenson document timeline.
/// </summary>
public enum JensonEventType
{
    /// <summary>
    /// The narrator is currently speaking.
    /// </summary>
    Narration,
    
    /// <summary>
    /// A character is currently speaking.
    /// </summary>
    Dialogue,
    
    /// <summary>
    /// A request to refresh the scene is being made. This can be for image or sound changes.
    /// </summary>
    Refresh,
    
    /// <summary>
    /// A question is being asked with a menu of choices.
    /// </summary>
    Question,
    
    /// <summary>
    /// A choice as part of a series of choices.
    /// </summary>
    Choice
}

/// <summary>
/// An interface declaring a class representing a Jenson event.
/// </summary>
public interface IJensonEvent
{
    /// <summary>
    /// The event type this class represents.
    /// </summary>
    public JensonEventType EventType { get; }
}

/// <summary>
/// A dialogue event where a character speaks.
/// </summary>
/// <param name="Who">The character that is currently speaking.</param>
/// <param name="What">The message or line of dialogue the character is speaking.</param>
public record DialogueEvent(string Who, string What): IJensonEvent
{
    public JensonEventType EventType => JensonEventType.Dialogue;
}

/// <summary>
/// An event where the narrator is currently speaking.
/// </summary>
/// <param name="What">The message or line of dialogue the narrator is speaking.</param>
public record NarrationEvent(string What) : IJensonEvent
{
    public JensonEventType EventType => JensonEventType.Narration;
}

/// <summary>
/// An event where one or more parts of the scene are being refreshed.
/// </summary>
/// <param name="What">The content that will be displayed or used.</param>
/// <param name="Kind">The type of refresh event occuring. Typically, image, sound, or music.</param>
/// <param name="Priority">The priority layer in where the refresh will occur.</param>
public record RefreshEvent(string What, string Kind, int Priority = 0) : IJensonEvent
{
    public JensonEventType EventType => JensonEventType.Refresh;
}

/// <summary>
/// An event where a question is being asked, along with a series of choices that the player can choose.
/// </summary>
/// <param name="What">The question being asked.</param>
/// <param name="Choices">The available choices that the player can pick from.</param>
/// <param name="Who">The person asking, when applicable. Defaults to no character.</param>
public record QuestionEvent(string What, ChoiceEvent[] Choices, string Who=""): IJensonEvent
{
    public JensonEventType EventType => JensonEventType.Question;
}

/// <summary>
/// An event that represents a choice.
/// </summary>
/// <param name="What">The name of the choice, or the response to the question.</param>
/// <param name="Events">The list of events that follow should this choice be selected.</param>
public record ChoiceEvent(string What, IJensonEvent[] Events): IJensonEvent
{
    public JensonEventType EventType => JensonEventType.Choice;
}
