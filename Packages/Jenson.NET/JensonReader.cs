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

            return new Story(name, authorsQuery.ToArray(), null, null);
        }
    }
}
