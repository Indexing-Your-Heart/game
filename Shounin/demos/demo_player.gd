extends CharacterBody2D

@onready var sprite = $Sprite
@onready var anim_tree = $Sprite/AnimationTree
@onready var anim_player = $Sprite/AnimationPlayer
@onready var anim_state = anim_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback

@export var speed = 200
@export var friction = 100

const zero = Vector2.ZERO
const acceleration = 250

func _physics_process(_delta):
	var move_vector = _get_movements()
	if move_vector != zero:
		_update_blending(move_vector)
		anim_state.travel("Walk")
		velocity += move_vector * acceleration
		velocity = velocity.limit_length(speed)
	else:
		anim_state.travel("Idle")
		velocity = velocity.move_toward(zero, friction)
	move_and_slide()

func _get_movements() -> Vector2:
	var movement = zero
	movement.x = _horizontal_movement_diff()
	movement.y = _vertical_movement_diff()
	return movement.normalized()

func _horizontal_movement_diff() -> float:
	return Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

func _vertical_movement_diff() -> float:
	return Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

func _update_blending(vector: Vector2):
	anim_tree.set("parameters/Idle/blend_position", vector)
	anim_tree.set("parameters/Walk/blend_position", vector)
