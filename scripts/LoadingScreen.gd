extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BlinkTimer_timeout():
	$EllipsisLabel.visible = !$EllipsisLabel.visible


func _on_LoadTimer_timeout():
	print("Going to Next Level from Loading Screen")
	get_tree().change_scene("res://scenes/Level.tscn")
