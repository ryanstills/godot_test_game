extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_level_lists()
	game_state.window_size = get_viewport().size
	game_state.MAX_XPOS = game_state.window_size.x - 96
	game_state.MAX_YPOS = game_state.window_size.y - 80
	
	
	$BackWheelAnimation.play()
	$FrontWheelAnimation.play()

func get_level_lists():
	var files = {}
	var count = 0
	var dir = Directory.new()
	dir.open(game_state.level_directory)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == '':
			break
		elif not file.begins_with("."):
			files[count] = file
			count += 1
	dir.list_dir_end()
	game_state.level_files = files

func _on_Timer_timeout():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/MainMenu.tscn")


func _on_WheelAnimationTimer_timeout():
	$BackWheelAnimation.stop()
	$FrontWheelAnimation.stop()
