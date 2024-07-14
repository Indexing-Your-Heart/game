using Xunit;
using Jenson.NET;

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
    }
}
