extends Node

const SERVER_PORT = 11235
const SERVER_IP = "127.0.0.1"

onready var _start_button = get_node("Gui/Start_button")

var peer = null
var _is_connected= false

func _ready():
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	initialize_connection()

func initialize_connection():
	$Try_to_connect_to_server_timer.start()
	connect_to_server()
	_start_button.text = "Connecting..."

func connect_to_server():
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	peer = WebSocketClient.new()
	peer.connect_to_url("ws://" + SERVER_IP + ":" + str(SERVER_PORT), PoolStringArray(), true)
	get_tree().set_network_peer(peer)

func _on_Button_pressed():
	get_tree().change_scene("res://Game/Game.tscn")

func _connected_to_server():
	$Try_to_connect_to_server_timer.stop()
	_is_connected = true
	_start_button.disabled = false
	Networking.get_clicker_count_from_server()
	_start_button.text = "Start"

func _on_Try_to_connect_to_server_timer_timeout():
	if !_is_connected:
		connect_to_server()
