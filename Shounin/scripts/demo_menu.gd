extends Window

@onready var stack = $Container/VBoxContainer
@onready var btn_env = stack.get_node("EnvironmentDemo") as Button
@onready var btn_prot = stack.get_node("ProtractorDemo") as Button
@onready var btn_jesn = stack.get_node("JensonDemo") as Button

# Called when the node enters the scene tree for the first time.
func _ready():
	btn_env.pressed.connect(func():
		get_tree().change_scene_to_file("res://demos/environment_demo.tscn")
	)
	btn_prot.pressed.connect(func():
		get_tree().change_scene_to_file("res://demos/protractor_demo.tscn")
	)
	btn_jesn.pressed.connect(func():
		get_tree().change_scene_to_file("res://demos/jenson_demo.tscn")
	)
