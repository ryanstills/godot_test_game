extends Node

# Declare member variables here. Examples:
# var a = 2
var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	game_state.current_level = game_state.current_level + 1
	game_state.level_history.push_front(game_state.current_level)
	print("Current Level: " + str(game_state.current_level))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = $Player
	player.position.x = player.position.x + (speed * delta)
	player.position.y = player.position.y + (speed * delta)


func _on_MainMenuButton_pressed():
	print("Returning to the Main Menu")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/MainMenu.tscn")


func _on_NextLevelButton_pressed():
	print("Going to the next level")
	get_tree().change_scene("res://scenes/LoadingScreen.tscn")


func _on_RightWallArea_area_entered(area):
	$Player.position.x = game_state.window_size.x - 65

func _on_LeftWallArea_area_entered(area):
	$Player.position.x = 65


func _on_TopWallArea_area_entered(area):
	$Player.position.x = 65


func _on_BottomWallArea_area_entered(area):
	$Player.position.x = game_state.window_size.y - 65
