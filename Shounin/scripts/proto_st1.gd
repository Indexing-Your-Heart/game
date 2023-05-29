extends Node2D

@onready var targets: Array = $Targets.get_children().map(func(child):
	return child as Target
	)

@onready var paintbrush: PuzzlePanel = $"Puzzle Panel"

var solved = []

# Called when the node enters the scene tree for the first time.
func _ready():
	paintbrush.solved_puzzle.connect(func(pzl_name):
		if pzl_name not in solved:
			solved.append(pzl_name)
		_close_panel()
	)
	for target in targets:
		target.target_activated.connect(func(trgt_name):
			_set_puzzle(trgt_name))

func _input(event):
	if event.is_action_pressed("cancel"):
		_close_panel()

func _set_puzzle(pzl_name: String):
	$Player.set_physics_process(false)
	paintbrush.visible = true
	paintbrush.set_puzzle(pzl_name)

func _close_panel():
	$Player.set_physics_process(true)
	paintbrush.visible = false
	paintbrush.set_process(false)
