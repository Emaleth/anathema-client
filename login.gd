extends PanelContainer


@onready var register_button := $VBoxContainer/RegisterButton

func _ready() -> void:
	$VBoxContainer/LoginButton.pressed.connect(login)

func login():
	#$VBoxContainer/LoginButton.disabled = true
	Gateway.ConnectToServer($VBoxContainer/EmailLineEdit.text, $VBoxContainer/PasswordLineEdit.text)
