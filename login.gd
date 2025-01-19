extends PanelContainer


@onready var register_button := $VBoxContainer/RegisterButton
@onready var login_button := $VBoxContainer/LoginButton

func _ready() -> void:
	login_button.pressed.connect(login)
	Gateway.connection_failed.connect(func(): login_button.disabled = false)
	Gateway.connection_failed.connect(func(): register_button.disabled = false)
	$VBoxContainer/EmailLineEdit.grab_focus()

func login():
	login_button.disabled = true
	register_button.disabled = true
	Gateway.ConnectToServer($VBoxContainer/EmailLineEdit.text, $VBoxContainer/PasswordLineEdit.text, false)
