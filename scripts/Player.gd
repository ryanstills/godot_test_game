extends Area2D

export var player_texture = preload("res://icon.png")

export var type = 'player'

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(position_x, position_y):
	$PlayerSprite.set_texture(player_texture)
	add_to_group("player")
	$".".position = Vector2(position_x + 32, position_y + 32)
