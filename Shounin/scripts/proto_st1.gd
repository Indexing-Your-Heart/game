extends Node2D

@onready var targets: Array = $Targets.get_children().map(func(child):
	return child as Target
	)

# Called when the node enters the scene tree for the first time.
func _ready():
	for target in targets:
		target.target_activated.connect(func(name):
			print("Fire! ", name))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
