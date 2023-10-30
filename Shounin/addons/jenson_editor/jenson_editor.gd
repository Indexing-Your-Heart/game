@tool
extends EditorPlugin

const EditorPanel = preload("res://addons/jenson_editor/editor_area.tscn")
var editor_instance

func _enter_tree():
	editor_instance = EditorPanel.instantiate()
	get_editor_interface().get_editor_main_screen().add_child(editor_instance)
	_make_visible(false)


func _exit_tree():
	if editor_instance:
		editor_instance.queue_free()

func _has_main_screen():
	return true

func _make_visible(visible):
	if editor_instance:
		editor_instance.visible = visible

func _get_plugin_name():
	return "Jenson"

func _get_plugin_icon():
	return preload("res://addons/jenson_editor/icons/message-square.svg")

