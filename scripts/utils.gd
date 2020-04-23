extends Node

func load_level_file(file_name):
		print("Filename: " + file_name)
		var contents = {}
		var file = File.new()
		file.open(game_state.level_directory + file_name, File.READ)
		var string_contents = file.get_as_text()
		contents = parse_json(string_contents)
		file.close()
		return contents
