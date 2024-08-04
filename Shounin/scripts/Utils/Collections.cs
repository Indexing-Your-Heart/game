#region Copyright
//
//  Collections.cs
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 21/7/2024.
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

using System.Collections.Generic;

namespace IndexingYourHeart.Utils;

public static class CollectionUtils
{
    /// <summary>
    /// Retrieves the first item in the list after removing it from the array.
    /// </summary>
    /// <param name="list">The list to remove the first item from.</param>
    /// <typeparam name="T">The type of the list's elements.</typeparam>
    /// <returns>The first item in the list, or null if the list is empty.</returns>
    public static T RemoveFirst<T>(this List<T> list)
    {
        T firstItem = list[0];
        list.RemoveAt(0);
        return firstItem;
    }

    public static T RemoveLast<T>(this List<T> list)
    {
        T lastItem = list[^1];
        list.RemoveAt(list.Count - 1);
        return lastItem;
    }
}
