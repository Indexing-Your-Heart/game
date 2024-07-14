[Serializable]
public class JensonReaderException : Exception
{
    public static string EmptyMessage = "File is empty or null.";
    public static string MissingHeader = "File has no Jenson header.";
    public static string MissingRequiredChildren = "File is missing required children: timeline, story.";
    public static string MissingStoryChildren = "The story block is missing its required children: name, authors.";
    public static string KdlReaderError = "The KDL document parser encountered an error.";

    public JensonReaderException() { }
    public JensonReaderException(string message) : base(message) { }
    public JensonReaderException(string message, Kadlet.KdlException innerException): base(message, innerException) { }
}
