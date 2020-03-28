extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	game_state.window_size = get_viewport().size
	print("Loading...")
	print("Current Level: " + str(game_state.current_level))
	set_process(true)
	$BackWheelAnimation.play()
	$FrontWheelAnimation.play()


#func _process(delta):
#	pass


func _on_Timer_timeout():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/MainMenu.tscn")


func _on_WheelAnimationTimer_timeout():
	$BackWheelAnimation.stop()
	$FrontWheelAnimation.stop()