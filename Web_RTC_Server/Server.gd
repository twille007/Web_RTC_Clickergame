extends Node

var peer = null
const SERVER_PORT = 11235

func _ready():
	start_server()

func start_server():
	peer = WebSocketServer.new()
	peer.listen(SERVER_PORT, PoolStringArray(), true)
	get_tree().connect("server_disconnected", self, "_close_network")
	get_tree().set_network_peer(peer)
	print("Server started.")

func _close_network():
	if get_tree().is_connected("server_disconnected", self, "_close_network"):
		get_tree().disconnect("server_disconnected", self, "_close_network")
	get_tree().set_network_peer(null)
