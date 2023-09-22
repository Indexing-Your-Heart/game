extends Control

@onready var keyboard = $Keyboard
@onready var label = $Label
@onready var textField = $TextField

func _ready():
	keyboard.connect("key_pressed", func (key):
		label.text = "Pressed a key: " + key + "!"
		
		if key == "ashashat_key_delete":
			textField.text = textField.text.substr(0, textField.text.length() - 2)
			return
		textField.text = textField.text + key.trim_prefix("ashashat_key_")
	)
