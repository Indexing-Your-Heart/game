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

namespace Jenson.NET.Models
{
    public record StoryChapter(int chapterNumber, string title);
    public record Story(string title, string[] authors, StoryChapter? chapter, string? copyright);

    public partial class JensonEvent;

    public record JensonDocument(Story story, JensonEvent[] timeline);
}
