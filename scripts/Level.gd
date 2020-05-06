extends Node

export (PackedScene) var Block
onready var utils = get_node("/root/utils")

# Declare member variables here. Examples:
var speed = 64
var movement_time = 0.0

var key_count = 0

var move_right = Vector2(speed, 0)
var move_left = Vector2(speed * -1, 0)
var move_up = Vector2(0, speed * -1)
var move_down = Vector2(0, speed)

var moves = [move_up, move_down, move_left, move_right]

# Called when the node enters the scene tree for the first time.
func _ready():
	game_state.block_broken = 0
	game_state.time_left = 0
	speed = speed
	key_count = -1
	
	game_state.level_state = {}
	game_state.current_level = game_state.current_level + 1
	game_state.level_history.push_front(game_state.current_level)
		
	if game_state.level_files.has(game_state.current_level):
		var level_content = utils.load_level_file(game_state.level_files[game_state.current_level])
		level_setup(level_content)
	set_process(true)
	$TimerBackground/LevelTimer.start()
	

func _process(delta):
	var player = $Player
	updateTimerText()
	if movement_time < 0.15:
		movement_time += delta
	else:
		var prev_position = player.position
		var new_position = null
		var move_direction = null
		
		if Input.is_action_pressed("ui_up"):
			new_position = Vector2(player.position.x, player.position.y - speed)
			move_direction = game_state.Move.UP
			movement_time = 0.0
		elif Input.is_action_pressed("ui_down"):
			new_position = Vector2(player.position.x, player.position.y + speed)
			move_direction = game_state.Move.DOWN
			movement_time = 0.0
		elif Input.is_action_pressed("ui_left"):
			new_position = Vector2(player.position.x - speed, player.position.y)
			move_direction = game_state.Move.LEFT
			movement_time = 0.0
		elif Input.is_action_pressed("ui_right"):
			new_position = Vector2(player.position.x + speed, player.position.y)
			move_direction = game_state.Move.RIGHT
			movement_time = 0.0
		
		if new_position != null:
			var valid = false
			valid = move_valid(player, move_direction, new_position)
			
			if valid:
				process_move(player, prev_position, new_position, move_direction)
		
		if key_count == 0:
			game_state.time_left = $TimerBackground/LevelTimer.time_left
			$AllKeysCollectedLayer/AllKeysCollected.show()
			set_process(false)
			$ChangeToScoreScreenTimer.start()

func _on_MainMenuButton_pressed():
	print("Returning to the Main Menu")
# warning-ignore:return_value_discarded
	$AllKeysCollectedLayer/AllKeysCollected.hide()
	get_tree().change_scene("res://scenes/MainMenu.tscn")

func _on_NextLevelButton_pressed():
	print("Going to the next level")
# warning-ignore:return_value_discarded
	$AllKeysCollectedLayer/AllKeysCollected.hide()
	get_tree().change_scene("res://scenes/LoadingScreen.tscn")

func _on_ChangeToScoreScreenTimer_timeout():
	get_tree().change_scene("res://scenes/ScoreScreen.tscn")

func updateTimerText():
	$TimerBackground/TimerText.set_text(str(round($TimerBackground/LevelTimer.time_left)))

func move_valid(block, move_direction, new_position):
	var move_valid = false
	if game_state.in_play_field(new_position):
		move_valid = true
	else:
		return false
	
	if game_state.block_exists_at_position(new_position) and block.is_in_group("player"):
		for block in game_state.level_state[String(new_position)]:
			var result = !block.valid_move_direction.has(move_direction)
			if result:
				return false
			elif block.is_in_group("key"):
				return true
			elif move_valid(block, move_direction, block.position + moves[move_direction]):
				move_valid = true
			else:
				move_valid = false
	elif game_state.block_exists_at_position(new_position) and !block.is_in_group("player"):
		for block in game_state.level_state[String(new_position)]:
			if block.is_in_group("breakable") or block.is_in_group("key"):
				move_valid = true
			else:
				move_valid = false
	
	return move_valid

func process_move(moving_unit, prev_position, new_position, move_direction):
	
	if game_state.block_exists_at_position(new_position) and !game_state.level_state[String(new_position)][0].is_in_group("key"):
		if game_state.block_exists_at_position(new_position + moves[move_direction]) and !game_state.level_state[String(new_position + moves[move_direction])][0].is_in_group("key") :
			var breakable_block = game_state.level_state[String(new_position + moves[move_direction])][0]
			game_state.level_state.erase(String(new_position + moves[move_direction]))
			breakable_block.queue_free()
			game_state.block_broken += 1
		
		var block = game_state.level_state[String(new_position)][0]
		block.position = new_position + moves[move_direction]
		game_state.update_level_state(new_position, new_position + moves[move_direction], block)
	elif game_state.block_exists_at_position(new_position) and game_state.level_state[String(new_position)][0].is_in_group("key"):
		var block = game_state.level_state[String(new_position)][0]
		game_state.level_state.erase(String(new_position))
		key_count = key_count - 1
		block.queue_free()
	
	moving_unit.position = new_position
	game_state.update_level_state(prev_position, new_position, moving_unit)
	
	if game_state.level_state[String(new_position)].size() > 1:
		for block in game_state.level_state[String(new_position)]:
			if block.is_in_group("key"):
				game_state.level_state[String(new_position)].pop_back()
				key_count = key_count - 1
				block.queue_free()

# x axis sections 18
# y axis sections 9
func level_setup(level_content):
	
	$MainMenuButton.disabled = true
	$NextLevelButton.disabled = true
	$MainMenuButton.hide()
	$NextLevelButton.hide()
	
	var count = 0

	for i in range(1, level_content.keys().size()):
		var key = str(i)
		var block = null
		# sets up all movement block
		if level_content[key]["block_type"] == 1:
			block = Block.instance()
			block.init(level_content[key]["block_type"], level_content[key]["position_x"], level_content[key]["position_y"])
			block.z_index = 1
			add_child(block)
		# set up left movement block
		elif level_content[key]["block_type"] == 2:
			block = Block.instance()
			block.init(level_content[key]["block_type"], level_content[key]["position_x"], level_content[key]["position_y"])
			block.z_index = 1
			add_child(block)
		# set up right movement block
		elif level_content[key]["block_type"] == 3:
			block = Block.instance()
			block.init(level_content[key]["block_type"], level_content[key]["position_x"], level_content[key]["position_y"])
			block.z_index = 1
			add_child(block)
		# set up up movement block
		elif level_content[key]["block_type"] == 4:
			block = Block.instance()
			block.init(level_content[key]["block_type"], level_content[key]["position_x"], level_content[key]["position_y"])
			block.z_index = 1
			add_child(block)
		# set up down movement block
		elif level_content[key]["block_type"] == 5:
			block = Block.instance()
			block.init(level_content[key]["block_type"], level_content[key]["position_x"], level_content[key]["position_y"])
			block.z_index = 1
			add_child(block)
		# sets up breakable block
		elif level_content[key]["block_type"] == 6:
			block = Block.instance()
			block.init(level_content[key]["block_type"], level_content[key]["position_x"], level_content[key]["position_y"])
			block.z_index = 1
			add_child(block)
		# set up unbreakable block
		elif level_content[key]["block_type"] == 7:
			block = Block.instance()
			block.init(level_content[key]["block_type"], level_content[key]["position_x"], level_content[key]["position_y"])
			block.z_index = 1
			add_child(block)
		# sets up player
		elif level_content[key]["block_type"] == 8:
			$Player.position = Vector2(level_content[key]["position_x"] + 32, level_content[key]["position_y"] + 32)
			game_state.level_state[String($Player.position)] = [$Player]
		# sets up keys
		elif level_content[key]["block_type"] == 9:
			count = count + 1
			block = Block.instance()
			block.init(level_content[key]["block_type"], level_content[key]["position_x"], level_content[key]["position_y"])
			add_child(block)
		if block != null:
			game_state.level_state[String(block.position)] = [block]
	key_count = count
	
	$MainMenuButton.disabled = false
	$NextLevelButton.disabled = false
	$MainMenuButton.show()
	$NextLevelButton.show()
