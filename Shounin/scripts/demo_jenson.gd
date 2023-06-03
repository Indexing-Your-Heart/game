extends Control

@onready var timeline: JensonTimeline = $JensonTimeline


# Called when the node enters the scene tree for the first time.
func _ready():
	timeline.timeline_finished.connect(func():
		get_tree().change_scene_to_file("res://demos/demo_menu.tscn")
	)
