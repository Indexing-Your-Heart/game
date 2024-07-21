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
using System.Collections;

namespace Jenson.NET
{
    public class JensonReader
    {
        static readonly string[] _requiredJensonChildren = ["story", "timeline"];
        static readonly string[] _requiredStoryMetadata = ["name", "authors"];

        string _sourceContents;

        public JensonReader(string sourceContents)
        {
            _sourceContents = sourceContents;
        }

        public JensonDocument Parse()
        {
            if (string.IsNullOrEmpty(_sourceContents))
                throw new JensonReaderException(JensonReaderException.EmptyMessage);

            KdlReader reader = new KdlReader();
            KdlDocument document = reader.Parse(_sourceContents);

            var jensonNodeQuery =
                from node in document.Nodes
                where node.Identifier == "jenson"
                select node;

            if (!jensonNodeQuery.Any())
                throw new JensonReaderException(JensonReaderException.MissingHeader);

            KdlNode jensonNode = jensonNodeQuery.First();
            var requiredChildrenQuery =
                from node in jensonNode.Children!.Nodes
                where _requiredJensonChildren.Contains(node.Identifier)
                select node;

            if (!GuardChildrenExist(jensonNode, _requiredJensonChildren))
                throw new JensonReaderException(JensonReaderException.MissingRequiredChildren);

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
                throw new JensonReaderException(JensonReaderException.MissingStoryChildren);

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

            int chapterNumberValue;
            if (node.Arguments.Any() && int.TryParse(node.Arguments[0].ToRawKdlString(), out chapterNumberValue) == true)
                chapterNumber = chapterNumberValue;
            return new StoryChapter(chapterNumber, chapterTitle);
        }
    }
}
