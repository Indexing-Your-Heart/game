#region Copyright
//
//  JensonReader_ParseErrorTests.cs
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

using Xunit;
using Jenson.NET;
using Jenson.NET.Models;

namespace Jenson.NET.Tests
{
    public class JensonReader_ParseErrorTests
    {
        [Fact]
        public void Test_EmptyFile_NoParse()
        {
            JensonReader reader = new("");
            var exception = Assert.Throws<JensonReaderException>(reader.Parse);
            Assert.Equal(JensonReaderException.KnownCase.EmptyOrNull.Description(), exception.Message);
        }

        [Fact]
        public void Test_FileMissingHeader_NoParse()
        {
            JensonReader reader = new("foo");
            var exception = Assert.Throws<JensonReaderException>(reader.Parse);
            Assert.Equal(JensonReaderException.KnownCase.MissingHeader.Description(), exception.Message);
        }

        [Fact]
        public void Test_FileMissingRequiredChildren_NoParse()
        {
            JensonReader reader = new(@"jenson {}");
            var exception = Assert.Throws<JensonReaderException>(reader.Parse);
            Assert.Equal(JensonReaderException.KnownCase.MissingRequiredChildren.Description(), exception.Message);
        }

        [Fact]
        public void Test_MissingStoryChildren_NoParse()
        {
            JensonReader reader = new(@"jenson {
                story {}
                timeline {}
             }");
            var exception = Assert.Throws<JensonReaderException>(reader.Parse);
            Assert.Equal(JensonReaderException.KnownCase.MissingStoryChildren.Description(), exception.Message);
        }
    }
}
