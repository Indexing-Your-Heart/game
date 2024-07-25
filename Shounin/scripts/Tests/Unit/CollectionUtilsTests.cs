#region Copyright
//
//  CollectionUtilsTests.cs
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 24/7/2024.
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

using GdUnit4;
using static GdUnit4.Assertions;
using System.Collections.Generic;
using IndexingYourHeart.Utils;

namespace IndexingYourHeart.Tests.Unit
{
    [TestSuite]
    public class CollectionUtilsTests
    {
        [TestCase]
        public void TestRemoveFirst()
        {
            List<string> aList = ["a", "b", "c"];
            var first = aList.RemoveFirst();

            AssertString(first).IsEqual("a");
            AssertInt(aList.Count).IsEqual(2);
        }
    }
}
