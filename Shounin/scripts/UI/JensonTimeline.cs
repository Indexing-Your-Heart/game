using System.Collections.Generic;
using System.Linq;
using Godot;
using Jenson.NET;
using Jenson.NET.Models;

public partial class JensonTimeline : Control
{
    private enum TimelineState
    {
        Initial,
        Loaded,
        Started,
        Playing,
        Ended
    }

    private static TimelineState[] UnsafeRefreshStates => [TimelineState.Initial, TimelineState.Loaded, TimelineState.Ended];

    [Export(PropertyHint.File, "*.jenson")]
    public string Script = "";

    private Dictionary<string, IJensonEvent> choices = new();
    private Button choiceTemplate;
    private IJensonEvent currentEvent;
    private JensonReader reader;
    private List<IJensonEvent> timeline;
    private TimelineState timelineState;

    #region Children Nodes
    private AnimationPlayer animator;
    private TextureRect backgroundLayer;
    private VBoxContainer menu;
    private TextureRect speakerLeft;
    private TextureRect speakerRight;
    private TextureRect speakerSingle;
    private Label whoLabel;
    private Label whatLabel;
    #endregion

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
	{
        animator = GetNode<AnimationPlayer>("AnimationPlayer");
        backgroundLayer = GetNode<TextureRect>("Background");
        menu = GetNode<VBoxContainer>("Choice Menu");
        speakerLeft = GetNode<TextureRect>("Multi Speakers/Left Speaker");
        speakerRight = GetNode<TextureRect>("Multi Speakers/Right Speaker");
        speakerSingle = GetNode<TextureRect>("Single Speaker");

        whoLabel = (Label)FindChild("Who Label", true);
        whatLabel = (Label)FindChild("What Label", true);

        choiceTemplate = menu.GetChild<Button>(0);

        menu.Visible = false;
        choiceTemplate.Visible = false;
        whoLabel.Text = "";
        whatLabel.Text = "";

        CreateReaderFromScript();
    }

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

    public override void _Input(InputEvent @event)
    {
        base._Input(@event);
        if (!Visible)
            return;
        if (Input.IsActionPressed("timeline_next") || Input.IsMouseButtonPressed(MouseButton.Left))
            HandleNextEvent();
    }

    private void CreateReaderFromScript()
    {
        using var file = FileAccess.Open(Script, FileAccess.ModeFlags.Read);
        reader = new JensonReader(file.GetAsText());
        timeline = reader.Parse().timeline.ToList();
    }

    private void HandleNextEvent()
    {
        if (animator == null || menu.Visible || timelineState == TimelineState.Started)
            return;
        if (animator.IsPlaying() && animator.CurrentAnimation != "start_timeline")
        {
            SkipAnimation();
            return;
        }

        Next();
    }

    private void Next()
    {
        if (timeline.Count == 0)
        {
            if (timelineState != TimelineState.Ended)
            {
                timelineState = TimelineState.Ended;
                GD.Print("Timeline has finished.");
                EmitSignal(SignalName.TimelineFinished);
                return;
            }
            GD.PushWarning("Attempted to move to an empty slot.");
            return;
        }
        currentEvent = timeline[0];
        timeline.RemoveAt(0);
        SetupWithCurrentEvent();
    }

    private void SetupWithCurrentEvent()
    {
        animator.Stop();
        switch (currentEvent.EventType)
        {
            case JensonEventType.Narration:
                SetupNarration();
                break;
            case JensonEventType.Dialogue:
                SetupDialogue();
                break;
            default:
                GD.PushWarning($"Unknown event type: {currentEvent.EventType}. Skipping.");
                Next();
                break;
        }
    }

    private void SetupDialogue()
    {
        DialogueEvent dialogue = (DialogueEvent)currentEvent;
        whoLabel.Text = dialogue.Who;
        whatLabel.Text = dialogue.What;
        animator.Play("speech", (double)dialogue.What.Length / 4);
    }

    private void SetupNarration()
    {
        NarrationEvent narration = (NarrationEvent)currentEvent;
        whatLabel.Text = narration.What;
        whoLabel.Text = "";
        animator.Play("speech", (double)narration.What.Length / 4);
    }

    private void SkipAnimation()
    {
        animator.Stop();
        whoLabel.VisibleRatio = 1;
        whatLabel.VisibleRatio = 1;

        backgroundLayer.Modulate = Colors.White;
        speakerLeft.Modulate = Colors.White;
        speakerRight.Modulate = Colors.White;
        speakerSingle.Modulate = Colors.White;
    }

    [Signal]
    public delegate void TimelineFinishedEventHandler();
}
