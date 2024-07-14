using Kadlet;

namespace Jenson.NET
{
    public static class KadletExtensions
    {
        public static string ToRawKdlString(this KdlValue value)
        {
            if (value.GetType() != typeof(KdlString))
                return value.ToKdlString();
            return value.ToKdlString().Replace("\"", String.Empty);
        }

        public static KdlNode? GetKdlNodeByIdentifier(this KdlNode node, string identifier)
        {
            return node.Children?.Nodes
                .Where(node => node.Identifier == identifier)
                .FirstOrDefault();
        }
    }
}
