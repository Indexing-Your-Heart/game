extends Control

@onready var numpad = $Numpad
@onready var textField = $TextField

func _ready():
	numpad.numpad_returned.connect(func (value):
		textField.text = "Entered value: " + str(value)
	)
