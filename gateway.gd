extends Node

var network := ENetMultiplayerPeer.new()
var ip := "127.0.0.1"
var port := 1910
var gateway_api := MultiplayerAPI.create_default_interface()

var username
var password

func _ready() -> void:
	ConnectToServer("a", "c")

func _process(_delta: float) -> void:
	if gateway_api.has_multiplayer_peer():
		gateway_api.poll()

func ConnectToServer(_username, _password):
	username = _username
	password = _password
	network.create_client(ip, port)
	get_tree().set_multiplayer(gateway_api, self.get_path())
	gateway_api.multiplayer_peer = network

	gateway_api.connection_failed.connect(_OnConnectionFailed)
	gateway_api.connected_to_server.connect(_OnConnectionSucceeded)
	gateway_api.server_disconnected.connect(_OnDisconnection)

func _OnConnectionFailed():
	print("Failed to connect to login server")


func _OnConnectionSucceeded():
	print("Succesfully connected to login server")


func _OnDisconnection():
	print("Succesfully disconnected to login server")
