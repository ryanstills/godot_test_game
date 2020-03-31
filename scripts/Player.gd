extends RigidBody2D

export var player_texture = preload("res://icon.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(position_x, position_y):
	$PlayerSprite.set_texture(player_texture)
	$".".position = Vector2(position_x + 32, position_y + 32)