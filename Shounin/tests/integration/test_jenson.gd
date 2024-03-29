extends GutTest

var _sender = InputSender.new(Input)
var test_scene: JensonTestcase

func before_each():
	test_scene = load("res://tests/scenes/jenson_testcase.tscn").instantiate()
	add_child_autoqfree(test_scene)
	await wait_seconds(2, "Loading initial scene")
	if not OS.get_environment("CI").is_empty():
		Input.flush_buffered_events()

## Test that the dialogue loads from the test script, and that the images are set.
func test_loads_into_dialogue():
	var who = test_scene.find_child("Who Label", true, false) as Label
	assert_not_null(who)
	assert_eq(who.text, "")
	
	var what = test_scene.find_child("What Label", true, false) as Label
	assert_not_null(what)
	assert_eq(what.text, "Chelsea walks up to the stage.")
	
	var background = test_scene.find_child("Background",true, false) as TextureRect
	assert_not_null(background.texture)
	assert_eq(background.texture.resource_path, "res://resources/backgrounds/ForestDay.png")
	
	var speaker = test_scene.find_child("Single Speaker",true, false) as TextureRect
	assert_not_null(speaker.texture)
	assert_eq(speaker.texture.resource_path, "res://resources/characters/chels_0.png")

## Test that the timeline advances when the action timeline_next is triggered.
func test_timeline_advances():
	_sender.action_down("timeline_next").hold_for(.1).wait(.3)
	if not OS.get_environment("CI").is_empty():
		Input.flush_buffered_events()
	await wait_for_signal(_sender.idle, 5)
	
	var who = test_scene.find_child("Who Label", true, false) as Label
	assert_not_null(who)
	assert_eq(who.text, "Chelsea")
	
	var what = test_scene.find_child("What Label", true, false) as Label
	assert_not_null(what)
	assert_eq(what.text, "Hello, world.")

## Test that the current animation halts when invoking timeline_text before the
## text is fully displayed.
func test_timeline_quickpass():
	_sender.action_down("timeline_next") \
		.hold_for(.1) \
		.action_up("timeline_next") \
		.action_down("timeline_next")
	if not OS.get_environment("CI").is_empty():
		Input.flush_buffered_events()
	await wait_for_signal(_sender.idle, 5)
	
	var what = test_scene.find_child("What Label", true, false) as Label
	assert_not_null(what)
	assert_eq(what.text, "Hello, world.")
	assert_eq(what.visible_ratio, 1.0)
