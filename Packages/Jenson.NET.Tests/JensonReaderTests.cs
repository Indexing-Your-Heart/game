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
    }
}
