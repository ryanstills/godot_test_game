extends Node

# global variables
var level_history = []
var current_level = -1
var	window_size = Vector2()
var random_generator = RandomNumberGenerator.new()
enum Move {UP, DOWN, LEFT, RIGHT}

# play field limits
var MIN_XPOS = 96
var MIN_YPOS = 96
var MAX_XPOS = 1280
var MAX_YPOS = 720

# sprite variables
var block_size = 64

# file information 
var level_directory = "res://levels/"
var level_files = {}

# end of level transition information
var time_left = 0
var block_broken = 0

# level information
var level_state = {}

func update_level_state(current_position, new_position, moving_object):
	remove_level_state_entry(current_position)
	add_level_state_entry(new_position, moving_object)

func remove_level_state_entry(position):
	if block_exists_at_position(position) and level_state[String(position)].size() > 1:
		level_state[String(position)].pop_front()
	else:
		level_state.erase(String(position))

func add_level_state_entry(position, object):
	if block_exists_at_position(position):
		level_state[String(position)].push_front(object)
	else:
		level_state[String(position)] = [object]


func in_play_field(position):
	return position.x >= MIN_XPOS and position.x <= MAX_XPOS and position.y >= MIN_YPOS and position.y <= MAX_YPOS

func block_exists_at_position(position):
	return level_state.has(String(position))
