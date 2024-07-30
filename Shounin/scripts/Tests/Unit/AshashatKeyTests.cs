#region Copyright
// AshashatKeyTests.cs
// Indexing Your Heart
// 
// Created by Marquis Kurt on 30/07/2024.
// 
// This file is part of Indexing Your Heart.
// 
// Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
// CNPLv7+ as found in the LICENSE file in the source code root directory or at
// <https://git.pixie.town/thufie/npl-builder>.
// 
// Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
// details.
#endregion

using GdUnit4;
using static GdUnit4.Assertions;
using IndexingYourHeart.Ashashat;
namespace IndexingYourHeart.Tests.Unit;

[TestSuite]
public class AshashatKeyTests
{
    [TestCase]
    public void KeyValueTests()
    {
        AssertString(AshashatKey.A.KeyValue()).Equals("a");
        AssertString(AshashatKey.E.KeyValue()).Equals("e");
        AssertString(AshashatKey.I.KeyValue()).Equals("i");
        AssertString(AshashatKey.U.KeyValue()).Equals("u");
    }
}
