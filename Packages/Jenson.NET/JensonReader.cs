#region Copyright
//
//  JensonReader.cs
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

using Kadlet;
using Jenson.NET.Models;

namespace Jenson.NET;

/// <summary>
/// A class that handles reading Jenson v3 files from a string.
/// </summary>
public class JensonReader(string sourceContents)
{
    static readonly string[] _requiredJensonChildren = ["story", "timeline"];
    static readonly string[] _requiredStoryMetadata = ["name", "authors"];

    /// <summary>
    /// Parses the current Jenson document into a readable timeline.
    /// </summary>
    /// <returns>A serialized representation of the current Jenson document.</returns>
    /// <exception cref="JensonReaderException">
    /// Thrown when the document is formatted incorrectly, or if the internal parser encountered an error.
    /// </exception>
    public JensonDocument Parse()
    {
        if (string.IsNullOrEmpty(sourceContents))
            throw new JensonReaderException(JensonReaderException.KnownCase.EmptyOrNull);

        KdlReader reader = new KdlReader();
        KdlDocument document = reader.Parse(sourceContents);

        var jensonNodeQuery =
            from node in document.Nodes
            where node.Identifier == "jenson"
            select node;

        if (!jensonNodeQuery.Any())
            throw new JensonReaderException(JensonReaderException.KnownCase.MissingHeader);

        KdlNode jensonNode = jensonNodeQuery.First();
        var requiredChildrenQuery =
            from node in jensonNode.Children!.Nodes
            where _requiredJensonChildren.Contains(node.Identifier)
            select node;

        if (!GuardChildrenExist(jensonNode, _requiredJensonChildren))
            throw new JensonReaderException(JensonReaderException.KnownCase.MissingRequiredChildren);

        KdlNode storyNode = jensonNode.GetKdlNodeByIdentifier("story")!;
        Story storyMetadata = ParseStoryFromNode(storyNode);

        KdlNode timeline = jensonNode.GetKdlNodeByIdentifier("timeline")!;
        IJensonEvent[] jensonEvents = ParseTimelineFromNode(timeline);

        return new JensonDocument(storyMetadata, jensonEvents);
    }

    private static IJensonEvent[] ParseTimelineFromNode(KdlNode timeline)
    {
        List<IJensonEvent> jensonEvents = [];
        if (timeline.Children == null)
            return [];

        foreach (KdlNode child in timeline.Children.Nodes)
        {
            switch (child.Identifier)
            {
                case "dialogue":
                    string speaker = child.Properties["who"].ToRawKdlString();
                    string dialogueContent = child.Arguments.First().ToRawKdlString();

                    DialogueEvent dialogue = new(speaker, dialogueContent);
                    jensonEvents.Add(dialogue);
                    continue;
                case "narration":
                    string narrationContent = child.Arguments.First().ToRawKdlString();
                    NarrationEvent narration = new(narrationContent);
                    jensonEvents.Add(narration);
                    continue;
                case "refresh":
                    string refreshKind = child.Properties["kind"].ToRawKdlString();
                    int priority = 0;

                    int priorityOut;
                    if (child.Properties.ContainsKey("priority") &&
                        int.TryParse(child.Properties["priority"].ToRawKdlString(), out priorityOut))
                    {
                        priority = priorityOut;
                    }

                    string contentToRefresh = child.Arguments.First().ToRawKdlString();
                    RefreshEvent refreshEvent = new(contentToRefresh, refreshKind, priority);
                    jensonEvents.Add(refreshEvent);
                    continue;
                case "question":
                    string questionContent = child.Arguments.First().ToRawKdlString();
                    string questionWho = "";
                    if (child.Properties.ContainsKey("who"))
                    {
                        questionWho = child.Properties["who"].ToRawKdlString();
                    }

                    if (child.Children == null)
                        continue;

                    List<ChoiceEvent> choices = [];
                    foreach (KdlNode choiceChild in child.Children.Nodes.Where((node) => node.Identifier == "choice"))
                    {
                        string choiceText = choiceChild.Arguments.First().ToRawKdlString();
                        IJensonEvent[] childEvents = ParseTimelineFromNode(choiceChild);
                        ChoiceEvent choiceEvent = new(choiceText, childEvents);
                        choices.Add(choiceEvent);
                    }

                    QuestionEvent questionEvent = new(questionContent, choices.ToArray(), questionWho);
                    jensonEvents.Add(questionEvent);
                    continue;
                default:
                    break;
            }
        }

        return jensonEvents.ToArray();
    }

    private static bool GuardChildrenExist(KdlNode node, string[] childrenIdentifiers)
    {
        var query =
            from child in node.Children!.Nodes
            where childrenIdentifiers.Contains(child.Identifier)
            select child;
        return query.Any();
    }

    private static Story ParseStoryFromNode(KdlNode storyNode)
    {
        if (!GuardChildrenExist(storyNode, _requiredStoryMetadata))
            throw new JensonReaderException(JensonReaderException.KnownCase.MissingStoryChildren);

        var name = storyNode.GetKdlNodeByIdentifier("name")?.Arguments[0].ToRawKdlString() ?? "";
        var authorsQuery =
            from author in storyNode.GetKdlNodeByIdentifier("authors")?.Arguments
            where author.GetType() == typeof(KdlString)
            select author.ToRawKdlString();

        var chapterNode = storyNode.GetKdlNodeByIdentifier("chapter");
        StoryChapter? chapter = null;
        if (chapterNode != null)
        {
            chapter = ParseChapterFromNode(chapterNode);
        }

        return new Story(name, authorsQuery.ToArray(), chapter, null);
    }

    private static StoryChapter ParseChapterFromNode(KdlNode node)
    {
        string chapterTitle = node.Properties["name"].ToRawKdlString() ?? "Untitled Chapter";
        int chapterNumber = 0;

        if (node.Arguments.Any() && int.TryParse(node.Arguments[0].ToRawKdlString(), out var chapterNumberValue) == true)
            chapterNumber = chapterNumberValue;
        return new StoryChapter(chapterNumber, chapterTitle);
    }
}
