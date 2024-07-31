#region Copyright
//
//  KadletExtensions.cs
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

namespace Jenson.NET
{
    public static class KadletExtensions
    {
        /// <summary>
        /// Gets the raw string of the current value.
        /// </summary>
        /// <param name="value">The value to get the raw string of.</param>
        /// <returns>
        /// Returns the raw string of the current value. For string values, the string is returned without quotation
        /// marks. Other types will return their normal values.
        /// </returns>
        public static string ToRawKdlString(this KdlValue value)
        {
            return value.GetType() != typeof(KdlString) ? value.ToKdlString() : value.ToKdlString().Replace("\"", string.Empty);
        }

        /// <summary>
        /// Retrieves a child KDL node by its identifier.
        /// </summary>
        /// <param name="node">The node to search its children for the specified node.</param>
        /// <param name="identifier">The identifier of the node to retrieve.</param>
        /// <returns>The first node whose identifier matches the query, or null if no nodes are found.</returns>
        public static KdlNode? GetKdlNodeByIdentifier(this KdlNode node, string identifier)
        {
            return (node.Children?.Nodes)
                .FirstOrDefault(node => node.Identifier == identifier);
        }
    }
}
