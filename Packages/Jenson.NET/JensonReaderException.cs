[Serializable]
public class JensonReaderException : Exception
{
    public static string EmptyMessage = "File is empty or null.";
    public static string MissingHeader = "File has no Jenson header.";

    public JensonReaderException() { }
    public JensonReaderException(string message) : base(message) { }
}
