class_name PuzzlePanel
extends CanvasLayer

@onready var painting = $Painting
@onready var drawer = $ProtractorDrawer

var _puzzle_name = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	drawer.recognized.connect(func(name):
		_recognized(name))
	
func set_puzzle(name: String):
	_puzzle_name = name
	painting.texture = load("res://resources/paintings/%s.png" % (_puzzle_name))

func _recognized(name: String):
	if name == _puzzle_name:
		solved_puzzle.emit(name)

signal solved_puzzle(name)
