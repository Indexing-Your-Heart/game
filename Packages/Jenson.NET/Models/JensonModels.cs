namespace Jenson.NET.Models
{
    public record StoryChapter(int chapterNumber, string title);
    public record Story(string title, string[] authors, StoryChapter? chapter, string? copyright);

    public partial class JensonEvent;

    public record JensonDocument(Story story, JensonEvent[] timeline);
}
