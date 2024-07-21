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

        [Fact]
        public void Test_Parse_Timeline_DialogueAndNarration()
        {
            JensonReader reader = new("""
            jenson {
                story {
                    name "The Third Eye"
                    authors "Renzo Nero" "Lorelei Weiss"
                }

                timeline {
                    dialogue who="Renate" "Hold me..."
                    narration "The woman fumbles around in the dark."
                }
            }
            """);
            JensonDocument document = reader.Parse();
            Assert.NotNull(document);
            Assert.Equal(2, document.timeline.Length);

            var firstEvent = document.timeline[0];
            Assert.NotNull(firstEvent);
            Assert.Equal(JensonEventType.Dialogue, firstEvent.EventType);
            DialogueEvent dialogue = (DialogueEvent)firstEvent;
            Assert.NotNull(dialogue);
            Assert.Equal("Renate", dialogue.who);
            Assert.Equal("Hold me...", dialogue.what);

            var lastEvent = document.timeline[1];
            Assert.NotNull(lastEvent);
            Assert.Equal(JensonEventType.Narration, lastEvent.EventType);
            NarrationEvent narration = (NarrationEvent)lastEvent;
            Assert.NotNull(narration);
            Assert.Equal("The woman fumbles around in the dark.", narration.what);
        }

        [Fact]
        public void Test_Parse_Timeline_Refresh()
        {
            JensonReader reader = new("""
            jenson {
                story {
                    name "Game Changer"
                    authors "Sam Reich" "Brennan Lee Mulligan"
                }

                timeline {
                    refresh "GameChanger_Logo" kind="image" priority=-1

                    // Get ready for a GAME CHANGER!
                    refresh "GameChanger_Intro_a1" kind="sound"
                    dialogue who="Sam" "Get ready for a GAME CHANGER!"
                }
            }
            """);
            JensonDocument document = reader.Parse();
            Assert.NotNull(document);
            Assert.Equal(3, document.timeline.Length);

            var firstEvent = document.timeline[0];
            Assert.NotNull(firstEvent);
            Assert.Equal(JensonEventType.Refresh, firstEvent.EventType);

            RefreshEvent imageRefreshEvent = (RefreshEvent)firstEvent;
            Assert.NotNull(imageRefreshEvent);
            Assert.Equal("GameChanger_Logo", imageRefreshEvent.what);
            Assert.Equal("image", imageRefreshEvent.kind);
            Assert.Equal(-1, imageRefreshEvent.priority);

            var nextEvent = document.timeline[1];
            Assert.NotNull(nextEvent);
            Assert.Equal(JensonEventType.Refresh, nextEvent.EventType);

            RefreshEvent soundRefreshEvent = (RefreshEvent)nextEvent;
            Assert.NotNull(soundRefreshEvent);
            Assert.Equal("GameChanger_Intro_a1", soundRefreshEvent.what);
            Assert.Equal("sound", soundRefreshEvent.kind);
            Assert.Equal(0, soundRefreshEvent.priority);
        }

        [Fact]
        void Test_Parse_Timeline_QuestionAndChoice()
        {
            JensonReader reader = new("""
            jenson {
                story {
                    name "A Whole New World"
                    authors "Marquis Kurt"
                }

                timeline {
                    question who="Amy" "No, really, who's there?" {
                        choice "Me!" {  }
                        choice "A ghost..." {  }
                    }
                }
            }
            """);
            JensonDocument document = reader.Parse();
            Assert.NotNull(document);
            Assert.Single(document.timeline);

            var firstEvent = document.timeline[0];
            Assert.NotNull(firstEvent);
            Assert.Equal(JensonEventType.Question, firstEvent.EventType);
        }
    }
}
