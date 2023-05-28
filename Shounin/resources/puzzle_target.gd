class_name Target
extends Area2D

@export var puzzle_name: String = ""

var _can_invoke = false

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(func(body):
		if body is CharacterBody2D:
			_can_invoke = true
	)
	body_exited.connect(func(body):
		if body is CharacterBody2D:
			_can_invoke = false
	)


func _input(event):
	if Input.is_action_just_pressed("interact") and _can_invoke:
		target_activated.emit(puzzle_name)

signal target_activated(puzzle_id)
