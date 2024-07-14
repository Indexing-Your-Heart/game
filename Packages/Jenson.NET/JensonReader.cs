using Kadlet;
using System.Linq;

namespace Jenson.NET
{
    public class JensonReader
    {
        string _sourceContents;

        public JensonReader(string sourceContents)
        {
            _sourceContents = sourceContents;
        }

        public void Parse()
        {
            if (string.IsNullOrEmpty(_sourceContents))
            {
                throw new JensonReaderException(JensonReaderException.EmptyMessage);
            }
            KdlReader reader = new KdlReader();
            KdlDocument document = reader.Parse(_sourceContents);

            var jensonNodeQuery =
                from node in document.Nodes
                where node.Identifier == "Jenson"
                select node;

            if (jensonNodeQuery.Count() == 0)
            {
                throw new JensonReaderException(JensonReaderException.MissingHeader);
            }

        }
    }
}
