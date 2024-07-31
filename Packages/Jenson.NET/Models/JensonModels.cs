#region Copyright
//
//  JensonModels.cs
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 14/7/2024.
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
/// A chapter in a Jenson story.
/// </summary>
/// <param name="chapterNumber">The chapter's corresponding number.</param>
/// <param name="title">The chapter's title.</param>
public record StoryChapter(int chapterNumber, string title);

/// <summary>
/// A story as defined in a Jenson document.
/// </summary>
/// <param name="title">The story's title.</param>
/// <param name="authors">The list of authors that created the file.</param>
/// <param name="chapter">Information about the current chapter, when applicable.</param>
/// <param name="copyright">A human-readable copyright string, when applicable.</param>
public record Story(string title, string[] authors, StoryChapter? chapter, string? copyright);

/// <summary>
/// A serialized Jenson document.
/// </summary>
/// <param name="story">Information about the current story.</param>
/// <param name="timeline">The list of events to play in the story.</param>
public record JensonDocument(Story story, IJensonEvent[] timeline);
