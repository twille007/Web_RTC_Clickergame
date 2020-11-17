extends Node

signal timer_top
signal timer_bottom

const BOTTOM = "bottom"
const TOP = "top"

var _clicker_count_top = 0
var _clicker_count_bottom = 0

remote func top_button_clicked():
	rpc("disable_top_button")
	_clicker_count_top += 1
	rpc("update_clicker_count", _clicker_count_bottom, _clicker_count_top)
	$Timer_top.start()
	
	if _clicker_count_top >= 10 && _clicker_count_bottom < 10:
		rpc("exclaim_winner", TOP)
		reset_game()
	
	yield(Networking, "timer_top")
	rpc("enable_top_button")

remote func bottom_button_clicked():
	rpc("disable_bottom_button")
	_clicker_count_bottom += 1
	rpc("update_clicker_count", _clicker_count_bottom, _clicker_count_top)
	$Timer_bottom.start()
	
	if _clicker_count_bottom >= 10 && _clicker_count_top < 10:
		rpc("exclaim_winner", BOTTOM)
		reset_game()
	
	yield(Networking, "timer_bottom")
	rpc("enable_bottom_button")

func reset_game():
	_clicker_count_bottom = 0
	_clicker_count_top = 0

remote func get_clicker_count(id):
	rpc_id(id, "update_clicker_count", _clicker_count_bottom, _clicker_count_top)

func _on_Timer_top_timeout():
	emit_signal("timer_top")
	$Timer_top.stop()

func _on_Timer_bottom_timeout():
	emit_signal("timer_bottom")
	$Timer_bottom.stop()
