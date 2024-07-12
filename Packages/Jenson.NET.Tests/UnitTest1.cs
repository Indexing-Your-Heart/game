using Xunit;
using Jenson.NET;

namespace Jenson.NET.Tests
{
    public class ExampleTests 
    {
        [Fact]
        public void Test_Assertion_MyClass_Init()
        {
            Class1 myClass = new(12);
            Assert.Equal(10, myClass.Foo);
        }
    }
}
