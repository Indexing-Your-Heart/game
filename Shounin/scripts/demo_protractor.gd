extends Node2D

@onready var drawer: ProtractorDrawer = $ProtractorDrawer
@onready var dbg_label: Label = $CanvasLayer/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	drawer.recognized.connect(_template_recognized)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _template_recognized(name: String):
	dbg_label.text = "[DEBUG] Best guess: %s\n" % name
	dbg_label.text += "Draw a line on the panel to get a gesture name."
