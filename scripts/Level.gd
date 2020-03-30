extends Node

export (PackedScene) var Block

# Declare member variables here. Examples:
var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	game_state.current_level = game_state.current_level + 1
	game_state.level_history.push_front(game_state.current_level)
	print("Current Level: " + str(game_state.current_level))
	level_setup(game_state.current_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = $Player
	
	player.position.x = clamp(player.position.x, game_state.MIN_XPOS, game_state.MAX_XPOS)
	player.position.y = clamp(player.position.y, game_state.MIN_YPOS, game_state.MAX_YPOS)

func _on_MainMenuButton_pressed():
	print("Returning to the Main Menu")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/MainMenu.tscn")

func _on_NextLevelButton_pressed():
	print("Going to the next level")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/LoadingScreen.tscn")
	
# x axis sections 18
# y axis sections 9
func level_setup(level):
	
	$MainMenuButton.disabled = true
	$NextLevelButton.disabled = true
	$MainMenuButton.hide()
	$NextLevelButton.hide()
	
	game_state.random_generator.randomize()
	var sample_map = []
	var sleep_timer = Timer.new()
	sleep_timer.set_wait_time(.3)
	add_child(sleep_timer)
	sleep_timer.start()
	
	var movement_block_count = 35
	var unbreakable_block_count = 25
	var breakable_block_count = 25
	var key_count = 5
	var player_count = 1
	
	for i in range(18 * 9):
		var num = game_state.random_generator.randi_range(0,9)
		if num > 0 and num <= 5:
			if movement_block_count <= 0:
				num = 0
			movement_block_count -= 1
		elif num == 6:
			if breakable_block_count <= 0:
				num = 0
			breakable_block_count -= 1
		elif num == 7:
			if unbreakable_block_count <= 0:
				num = 0
			unbreakable_block_count -= 1
		elif num == 8: 
			if player_count <= 0:
				num = 0
			player_count -= 1
		elif num == 9: 
			if key_count <= 0:
				num = 0
			key_count -= 1
		sample_map.append(num)
		
	var x_count = 1
	var y_count = 1
	
	for i in sample_map:
		if i != 0:
			var block = Block.instance()
			block.init(i)
			add_child(block)
			block.position = Vector2((x_count * game_state.block_size) + 32, (y_count * game_state.block_size) + 32)
			print(block.position)
			print(block.block_type)
			yield(sleep_timer, "timeout")
		x_count += 1
		if x_count > 18:
			y_count += 1
			x_count = 1
	sleep_timer.stop()
	sleep_timer.queue_free()

	$MainMenuButton.disabled = false
	$NextLevelButton.disabled = false
	$MainMenuButton.show()
	$NextLevelButton.show()