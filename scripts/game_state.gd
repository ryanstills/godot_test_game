extends Node

#global variables
var level_history = []
var current_level = -1
var	window_size = Vector2()
var random_generator = RandomNumberGenerator.new()

# play field limits
var MIN_XPOS = 96
var MIN_YPOS = 96
var MAX_XPOS = 1280
var MAX_YPOS = 720

# sprite variables
var block_size = 64