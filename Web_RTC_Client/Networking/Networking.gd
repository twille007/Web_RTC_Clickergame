extends Node

signal top_clicked
signal buttom_clicked

signal enable_top_button_signal
signal disable_top_button_signal
signal enable_bottom_button_signal
signal disable_bottom_button_signal
signal update_clicker_count_signal(clicker_count_bottom, clicker_count_top)
signal top_wins_signal
signal bottom_wins_signal

const BOTTOM = "bottom"
const TOP = "top"

remote func restart_game():
	get_tree().change_scene("res://Game/Game.tscn")

func button_top_pressed():
	rpc_id(1, "top_button_clicked")

func button_bottom_pressed():
	rpc_id(1, "bottom_button_clicked")

func get_clicker_count_from_server():
	rpc_id(1, "get_clicker_count", get_tree().get_network_unique_id())

remote func update_clicker_count(clicker_count_bottom, clicker_count_top):
	emit_signal("update_clicker_count_signal", clicker_count_bottom, clicker_count_top)

remote func enable_top_button():
	emit_signal("enable_top_button_signal")

remote func disable_top_button():
	emit_signal("disable_top_button_signal")

remote func enable_bottom_button():
	emit_signal("enable_bottom_button_signal")

remote func disable_bottom_button():
	emit_signal("disable_bottom_button_signal")

remote func exclaim_winner(winner):
	if winner == TOP:
		emit_signal("top_wins_signal")
	elif winner == BOTTOM:
		emit_signal("bottom_wins_signal")
