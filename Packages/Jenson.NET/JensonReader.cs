using Kadlet;
using Jenson.NET.Models;

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

            return new JensonDocument(storyMetadata, []);
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
