extends PanelContainer


@onready var login_button := $VBoxContainer/LoginButton
@onready var register_button := $VBoxContainer/RegisterButton


func _ready() -> void:
	register_button.pressed.connect(register)
	Gateway.con_f.connect(func(): login_button.disabled = false)
	Gateway.con_f.connect(func(): register_button.disabled = false)

func register():
	if $VBoxContainer/PasswordLineEdit.text == $VBoxContainer/RepeatPasswordLineEdit.text:
		login_button.disabled = true
		register_button.disabled = true
		Gateway.ConnectToServer($VBoxContainer/EmailLineEdit.text, $VBoxContainer/PasswordLineEdit.text, true)
