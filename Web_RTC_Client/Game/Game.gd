extends Node

onready var _top_button = get_node("GUI/Top_button")
onready var _bottom_button = get_node("GUI/Bottom_button")

func _ready():
	game_start()
	init_signals()

func game_start():
	Networking.get_clicker_count_from_server()
	_top_button.disabled = true
	_bottom_button.disabled = true
	$Button_timer.start()

func init_signals():
	Networking.connect("enable_top_button_signal", self, "activate_top_button")
	Networking.connect("disable_top_button_signal", self, "deactivate_top_button")
	Networking.connect("enable_bottom_button_signal", self, "activate_bottom_button")
	Networking.connect("disable_bottom_button_signal", self, "deactivate_bottom_button")
	Networking.connect("update_clicker_count_signal", self, "update_clicker_count")
	Networking.connect("top_wins_signal", self, "top_wins")
	Networking.connect("bottom_wins_signal", self, "bottom_wins")

func _on_Button_top_pressed():
	Networking.button_top_pressed()
	_top_button.disabled = true

func _on_Button_bottom_pressed():
	Networking.button_bottom_pressed()
	_bottom_button.disabled = true

func activate_top_button():
	_top_button.disabled = false

func deactivate_top_button():
	_top_button.disabled = true

func activate_bottom_button():
	_bottom_button.disabled = false

func deactivate_bottom_button():
	_bottom_button.disabled = true

func _on_Button_timer_timeout():
	$Button_timer.stop()
	_top_button.disabled = false
	_bottom_button.disabled = false

func update_clicker_count(clicker_count_bottom, clicker_count_top):
	_bottom_button.text = str(clicker_count_bottom)
	_top_button.text = str(clicker_count_top)

func top_wins():
	$GUI/Game_Screen/VBoxContainer/Bottom.size_flags_vertical = 1
	restart_game()

func bottom_wins():
	$GUI/Game_Screen/VBoxContainer/Top.size_flags_vertical = 1
	restart_game()

func restart_game():
	var timer = Timer.new()
	timer.set_wait_time(3)
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.start()
	yield(timer, "timeout")
	timer.queue_free()
	get_tree().change_scene("res://Game/Game.tscn")
