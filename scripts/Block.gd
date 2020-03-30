extends RigidBody2D

var block_type = ''
export var block_movable_all = preload("res://assets/sprites/block_movable_all.png")
export var block_movable_left = preload("res://assets/sprites/block_movable_left.png")
export var block_movable_right = preload("res://assets/sprites/block_movable_right.png")
export var block_movable_up = preload("res://assets/sprites/block_movable_up.png")
export var block_movable_down = preload("res://assets/sprites/block_movable_down.png")
export var block_breakable = preload("res://assets/sprites/block_breakable.png")
export var block_unbreakable = preload("res://assets/sprites/block_unbreakable.png")
export var player = preload("res://icon.png")
export var key = preload("res://assets/sprites/key.png")

var block_types = {
	1: "movable_all",
	2: "movable_left",
	3: "movable_right",
	4: "movable_up",
	5: "movable_down",
	6: "breakable",
	7: "unbreakable",
	8: "player",
	9: "key"
}

var block_textures = {
	"movable_all": block_movable_all,
	"movable_left": block_movable_left,
	"movable_right": block_movable_right,
	"movable_up": block_movable_up,
	"movable_down": block_movable_down,
	"breakable": block_breakable,
	"unbreakable": block_unbreakable,
	"player": player,
	"key": key
}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func init(type):
	block_type = block_types[type]
	$BlockSprite.set_texture(block_textures[block_type])
