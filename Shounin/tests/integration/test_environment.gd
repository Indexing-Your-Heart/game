extends GutTest

var _sender = InputSender.new(Input)
var test_scene: EnvironmentTestcase

func before_each():
	test_scene = load("res://tests/scenes/environment_testcase.tscn").instantiate()
	add_child_autoqfree(test_scene)
	await wait_seconds(2, "Initial setup")

# Test that the player moves.
func test_player_moves():
	var orig_position = Vector2(test_scene.player.position.x, test_scene.player.position.y)
	_sender.action_down("move_right").hold_for(2).wait(.1)
	await wait_seconds(3, "Player movement")
	assert_ne(test_scene.player.position, orig_position)
