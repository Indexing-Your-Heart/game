extends Node2D

@onready var numpad_puzzle = $CanvasLayer/NumpadPuzzleField

func _unhandled_key_input(event):
	if Input.is_action_pressed("interact"):
		numpad_puzzle.show()
