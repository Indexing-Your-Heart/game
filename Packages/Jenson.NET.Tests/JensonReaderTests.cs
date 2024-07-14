#region Copyright
//
//  JensonReaderTests.cs
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

using Xunit;
using Jenson.NET;
using Jenson.NET.Models;

namespace Jenson.NET.Tests
{
    public class JensonReaderTests
    {
        [Fact]
        public void Test_EmptyFile_NoParse()
        {
            JensonReader reader = new("");
            var exception = Assert.Throws<JensonReaderException>(reader.Parse);
            Assert.Equal(JensonReaderException.EmptyMessage, exception.Message);
        }

        [Fact]
        public void Test_FileMissingHeader_NoParse()
        {
            JensonReader reader = new("foo");
            var exception = Assert.Throws<JensonReaderException>(reader.Parse);
            Assert.Equal(JensonReaderException.MissingHeader, exception.Message);
        }

        [Fact]
        public void Test_FileMissingRequiredChildren_NoParse()
        {
            JensonReader reader = new(@"jenson {}");
            var exception = Assert.Throws<JensonReaderException>(reader.Parse);
            Assert.Equal(JensonReaderException.MissingRequiredChildren, exception.Message);
        }

        [Fact]
        public void Test_MissingStoryChildren_NoParse()
        {
            JensonReader reader = new(@"jenson {
                story {}
                timeline {}
             }");
            var exception = Assert.Throws<JensonReaderException>(reader.Parse);
            Assert.Equal(JensonReaderException.MissingStoryChildren, exception.Message);
        }

        [Fact]
        public void Test_Parse_BasicStory()
        {
            JensonReader reader = new("""
            jenson {
                story {
                    name "Hello World"
                    authors "Marquis Kurt" "John Smith"
                }

                timeline {}
            }
            """);
            JensonDocument document = reader.Parse();
            Assert.NotNull(document);
            Assert.Equal("Hello World", document.story.title);
            Assert.Equal(["Marquis Kurt", "John Smith"], document.story.authors);
        }

        [Fact]
        public void Test_Parse_FullStory()
        {
            JensonReader reader = new("""
            jenson {
                story {
                    name "Hello World"
                    authors "Marquis Kurt" "John Smith"
                    chapter 1 name="Nocens Mulier"
                    copyright "(C) 2024 Marquis Kurt and friends."
                }

                timeline {}
            }
            """);
            JensonDocument document = reader.Parse();
            Assert.NotNull(document);
            Assert.Equal("Hello World", document.story.title);
            Assert.Equal(["Marquis Kurt", "John Smith"], document.story.authors);
            Assert.Equal(1, document.story.chapter?.chapterNumber);
            Assert.Equal("Nocens Mulier", document.story.chapter?.title);
        }

        [Fact]
        public void Test_Parse_FullStory_MissingChapterNumber()
        {
            JensonReader reader = new("""
            jenson {
                story {
                    name "Hello World"
                    authors "Marquis Kurt" "John Smith"
                    chapter name="Nocens Mulier"
                    copyright "(C) 2024 Marquis Kurt and friends."
                }

                timeline {}
            }
            """);
            JensonDocument document = reader.Parse();
            Assert.NotNull(document);
            Assert.Equal("Hello World", document.story.title);
            Assert.Equal(["Marquis Kurt", "John Smith"], document.story.authors);
            Assert.Equal(0, document.story.chapter?.chapterNumber);
            Assert.Equal("Nocens Mulier", document.story.chapter?.title);
        }
    }
}
