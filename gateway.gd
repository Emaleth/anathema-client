extends Node

var network := ENetMultiplayerPeer.new()
var ip := "127.0.0.1"
var port := 1910
var gateway_api := MultiplayerAPI.create_default_interface()
var cert = load("res://X509_Certificate.crt")

var username
var password
var new_user := false

func _process(_delta: float) -> void:
	if not get_tree().get_multiplayer() == gateway_api:
		return
	if not gateway_api.has_multiplayer_peer():
		return
	gateway_api.poll()

func ConnectToServer(_username, _password, _new_user):
	network = ENetMultiplayerPeer.new()
	gateway_api = MultiplayerAPI.create_default_interface()
	username = _username
	password = _password
	new_user = _new_user
	network.create_client(ip, port)
	network.host.dtls_client_setup("hostname", TLSOptions.client_unsafe(cert))
	get_tree().set_multiplayer(gateway_api, self.get_path())
	gateway_api.multiplayer_peer = network

	gateway_api.connection_failed.connect(_OnConnectionFailed)
	gateway_api.connected_to_server.connect(_OnConnectionSucceeded)
	gateway_api.server_disconnected.connect(_OnDisconnection)

func _OnConnectionFailed():
	print("Failed to connect to login server")
	connection_failed.emit()


func _OnConnectionSucceeded():
	print("Succesfully connected to login server")
	if new_user == true:
		client_to_gateway_create_account()
	else:
		client_to_gateway_login()


func _OnDisconnection():
	print("Succesfully disconnected to login server")

@rpc("reliable")
func client_to_gateway_login():
	gateway_api.rpc(1, self, "client_to_gateway_login", [username, password.sha256_text()])
	username = ""
	password = ""

@rpc("reliable")
func client_to_gateway_create_account():
	gateway_api.rpc(1, self, "client_to_gateway_create_account", [username, password.sha256_text()])
	username = ""
	password = ""

signal connection_failed
@rpc("reliable")
func gateway_to_client_login_result(result, token):
	print(result)
	print(token)
	if result == true:
		Server.token = token
		Server.ConnectToServer()
	else:
		connection_failed.emit()
		gateway_api.connection_failed.disconnect(_OnConnectionFailed)
		gateway_api.connected_to_server.disconnect(_OnConnectionSucceeded)
		gateway_api.server_disconnected.disconnect(_OnDisconnection)

@rpc("reliable")
func gateway_to_client_create_account(result, message):
	print(result, message)

	if result == false:
		connection_failed.emit()
		#reenable buttons
	if result == true:
		get_tree().root.get_node("/root/Anathema").get_node("LoginRegister").load_login_scene()

		#switch to login screen
	gateway_api.connection_failed.disconnect(_OnConnectionFailed)
	gateway_api.connected_to_server.disconnect(_OnConnectionSucceeded)
	gateway_api.server_disconnected.disconnect(_OnDisconnection)
