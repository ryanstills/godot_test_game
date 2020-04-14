extends Node2D

# Declare member variables here. Examples:
var time_left = 0
var blocks_broken = 0
var total_score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	blocks_broken = int(game_state.block_broken)
	time_left = int(game_state.time_left)
	tallyBlockScore()

func tallyBlockScore():
	var wait = Timer.new()
	wait.set_wait_time(0.3)
	self.add_child(wait)
	wait.start()
	for i in range(0, blocks_broken):
		total_score += 1
		$ColorRect/BlocksBrokenText.set_text(str(i))
		yield(wait, "timeout")
	wait.queue_free()
	tallyTimeScore()

func tallyTimeScore():
	var wait = Timer.new()
	wait.set_wait_time(0.3)
	self.add_child(wait)
	wait.start()
	for i in range(1, time_left):
		total_score += 1
		$ColorRect/TimeLeftText.set_text(str(i))
		yield(wait, "timeout")
	wait.queue_free()
	tallyTotalScore()

func tallyTotalScore():
	var wait = Timer.new()
	wait.set_wait_time(0.3)
	self.add_child(wait)
	wait.start()
	for i in range(1, total_score):
		total_score += 1
		$ColorRect/TotalScoreText.set_text(str(i))
		yield(wait, "timeout")
	wait.queue_free()
	swapScene()
	
func swapScene():
	var wait = Timer.new()
	wait.set_wait_time(4)
	self.add_child(wait)
	wait.start()
	yield(wait, "timeout")
	get_tree().change_scene("res://scenes/Level.tscn")
	wait.queue_free()