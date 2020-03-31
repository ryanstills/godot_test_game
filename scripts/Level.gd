extends Node

export (PackedScene) var Block
export (PackedScene) var Player
onready var utils = get_node("/root/utils")

# Declare member variables here. Examples:
var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	game_state.current_level = game_state.current_level + 1
	game_state.level_history.push_front(game_state.current_level)
	if game_state.level_files.has(game_state.current_level):
		var level_content = utils.load_level_file(game_state.level_files[game_state.current_level])
		level_setup(level_content)

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
func level_setup(level_content):
	
	$MainMenuButton.disabled = true
	$NextLevelButton.disabled = true
	$MainMenuButton.hide()
	$NextLevelButton.hide()
	
	var count = 1
	for i in range(1, level_content.keys().size()):
		var key = str(i)
		if (level_content[key]["block_type"] >= 1 and level_content[key]["block_type"] <= 8) or level_content[key]["block_type"] == 9:
			var block = Block.instance()
			block.init(level_content[key]["block_type"], level_content[key]["position_x"], level_content[key]["position_y"])
			add_child(block)
		elif level_content[key]["block_type"] == 8:
			var player = Player.instance()
			player.init(level_content[key]["positon_x"], level_content[key]["position_y"])
			add_child(player)
		
	$MainMenuButton.disabled = false
	$NextLevelButton.disabled = false
	$MainMenuButton.show()
	$NextLevelButton.show()