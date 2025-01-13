extends PanelContainer


@onready var register_button := $VBoxContainer/RegisterButton
@onready var login_button := $VBoxContainer/LoginButton

func _ready() -> void:
	login_button.pressed.connect(login)
	Gateway.con_f.connect(func(): login_button.disabled = false)

func login():
	login_button.disabled = true
	Gateway.ConnectToServer($VBoxContainer/EmailLineEdit.text, $VBoxContainer/PasswordLineEdit.text, false)
