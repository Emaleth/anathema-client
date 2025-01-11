extends Node

var network := ENetMultiplayerPeer.new()
var ip := "127.0.0.1"
var port := 1910
var gateway_api := MultiplayerAPI.create_default_interface()

var username
var password


func _process(_delta: float) -> void:
	if not get_tree().get_multiplayer() == gateway_api:
		return
	if not gateway_api.has_multiplayer_peer():
		return
	gateway_api.poll()

func ConnectToServer(_username, _password):
	network = ENetMultiplayerPeer.new()
	gateway_api = MultiplayerAPI.create_default_interface()
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
	client_to_gateway_login()


func _OnDisconnection():
	print("Succesfully disconnected to login server")

@rpc("reliable")
func client_to_gateway_login():
	gateway_api.rpc(1, self, "client_to_gateway_login", [username, password])
	username = ""
	password = ""

signal con_f
@rpc("reliable")
func gateway_to_client_login_result(result, token):
	print(result)
	print(token)
	if result == true:
		Server.token = token
		Server.ConnectToServer()
	else:
		con_f.emit()
		gateway_api.connection_failed.disconnect(_OnConnectionFailed)
		gateway_api.connected_to_server.disconnect(_OnConnectionSucceeded)
		gateway_api.server_disconnected.disconnect(_OnDisconnection)
