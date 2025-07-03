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
[RequireGodotRuntime]
public class AshashatKeyTests
{
    [TestCase]
    public void TestKeyValueMatches()
    {
        AssertString(AshashatKey.A.KeyValue()).Equals("a");
        AssertString(AshashatKey.E.KeyValue()).Equals("e");
        AssertString(AshashatKey.I.KeyValue()).Equals("i");
        AssertString(AshashatKey.U.KeyValue()).Equals("u");

        AssertString(AshashatKey.P.KeyValue()).Equals("p");
        AssertString(AshashatKey.B.KeyValue()).Equals("b");
        AssertString(AshashatKey.T.KeyValue()).Equals("t");
        AssertString(AshashatKey.K.KeyValue()).Equals("k");
        AssertString(AshashatKey.S.KeyValue()).Equals("s");
        AssertString(AshashatKey.L.KeyValue()).Equals("l");
        AssertString(AshashatKey.N.KeyValue()).Equals("n");
        AssertString(AshashatKey.Glottal.KeyValue()).Equals("ʔ");
        AssertString(AshashatKey.EjectiveK.KeyValue()).Equals("k'");
        AssertString(AshashatKey.Sh.KeyValue()).Equals("ʃ");

        AssertString(AshashatKey.Repeater.KeyValue()).Equals("*");
        AssertString(AshashatKey.Duplicant.KeyValue()).Equals("!");
        AssertString(AshashatKey.Return.KeyValue()).IsEmpty();
        AssertString(AshashatKey.Delete.KeyValue()).IsEmpty();
    }

    [TestCase]
    public void TestFontRenderedValueMatches()
    {
        AssertString(AshashatKey.A.FontRenderedValue()).Equals("a");
        AssertString(AshashatKey.E.FontRenderedValue()).Equals("e");
        AssertString(AshashatKey.I.FontRenderedValue()).Equals("i");
        AssertString(AshashatKey.U.FontRenderedValue()).Equals("u");

        AssertString(AshashatKey.P.FontRenderedValue()).Equals("p");
        AssertString(AshashatKey.B.FontRenderedValue()).Equals("b");
        AssertString(AshashatKey.T.FontRenderedValue()).Equals("t");
        AssertString(AshashatKey.K.FontRenderedValue()).Equals("k");
        AssertString(AshashatKey.S.FontRenderedValue()).Equals("s");
        AssertString(AshashatKey.L.FontRenderedValue()).Equals("l");
        AssertString(AshashatKey.N.FontRenderedValue()).Equals("n");
        AssertString(AshashatKey.Glottal.FontRenderedValue()).Equals("ʔ");
        AssertString(AshashatKey.EjectiveK.FontRenderedValue()).Equals("K");
        AssertString(AshashatKey.Sh.FontRenderedValue()).Equals("sh");

        AssertString(AshashatKey.Repeater.KeyValue()).Equals(":");
        AssertString(AshashatKey.Duplicant.KeyValue()).Equals("*");
        AssertString(AshashatKey.Return.KeyValue()).IsEmpty();
        AssertString(AshashatKey.Delete.KeyValue()).IsEmpty();
    }
}
