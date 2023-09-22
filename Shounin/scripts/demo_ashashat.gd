extends Control

@onready var keyboard = $Keyboard
@onready var label = $Label
@onready var textField = $TextField

func _ready():
	keyboard.connect("key_pressed", func (key):
		label.text = "Pressed a key: " + key + "!"
		
		if key == "ashashat_key_delete":
			textField.text = textField.text.substr(0, textField.text.length() - 1)
			return
		if key == "ashashat_key_return":
			print("Returned " + textField.text)
			return
		if key == "ashashat_key_glottal":
			textField.text = textField.text + "ʔ"
			return
		if key == "ashashat_key_ejective_k":
			textField.text = textField.text + "K"
			return
		textField.text = textField.text + key.trim_prefix("ashashat_key_")
	)
