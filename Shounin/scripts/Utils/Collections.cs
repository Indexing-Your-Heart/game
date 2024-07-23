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

namespace IndexingYourHeart.Utils
{
    public static class CollectionUtils
    {
       public static T RemoveFirst<T>(this List<T> list)
        {
            var firstItem = list[0];
            list.RemoveAt(0);
            return firstItem;
        }
    }
}
