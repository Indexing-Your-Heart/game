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
