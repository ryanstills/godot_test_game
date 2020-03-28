extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	game_state.current_level = 0
	game_state.level_history.push_front(game_state.current_level)
	print("Main Menu Script Running")
	print("Current Level: " + str(game_state.current_level))

#func _process(delta):
#	pass


func _on_StartGameButton_pressed():
	print("Start Button Pressed")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/Level.tscn")


func _on_QuitGameButton_pressed():
	print("Quit Button Pressed")
	get_tree().quit()
