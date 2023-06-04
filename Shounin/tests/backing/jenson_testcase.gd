class_name JensonTestcase
extends Control

@onready var timeline: JensonTimeline = $JensonTimeline

var timeline_ended = false

# Called when the node enters the scene tree for the first time.
func _ready():
	timeline.timeline_finished.connect(func():
		timeline_ended = true
	)
