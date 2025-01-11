extends Node

var network := ENetMultiplayerPeer.new()
var ip := "127.0.0.1"
var port := 1989
var token

func ConnectToServer():
	network.create_client(ip, port)
	multiplayer.multiplayer_peer = network

	multiplayer.connection_failed.connect(_OnConnectionFailed)
	multiplayer.connected_to_server.connect(_OnConnectionSucceeded)
	multiplayer.server_disconnected.connect(_OnDisconnection)

func _OnConnectionFailed():
	print("Failed to connect")


func _OnConnectionSucceeded():
	print("Succesfully connected")


func _OnDisconnection():
	print("Succesfully disconnected")

@rpc("reliable")
func client_to_server_new_chat_message(text):
	multiplayer.rpc(1, self, "client_to_server_new_chat_message", [text])

signal new_msg
@rpc("reliable")
func server_to_client_broadcast_new_chat_message(sender, timestamp, text):
	new_msg.emit(sender, timestamp, text)

@rpc("reliable")
func server_to_client_token():
	client_to_server_token()

@rpc("reliable")
func client_to_server_token():
	print(token)
	multiplayer.rpc(1, self, "client_to_server_token", [token])

@rpc("reliable")
func server_to_player_token_result(token_verification):
	get_tree().root.get_node("/root/Anathema").switch_scene()
