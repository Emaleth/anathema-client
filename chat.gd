extends PanelContainer

@onready var chat_line := preload("res://chat_line.tscn").instantiate()
@onready var global_chat := $VBoxContainer/TabContainer/Global/VBoxContainer
@onready var line_edit := $VBoxContainer/LineEdit


func _ready() -> void:
	Server.new_msg.connect(add_new_message)

func add_new_message(sender, timestamp, msg):
	var new_line = chat_line.duplicate()
	global_chat.add_child(new_line)
	new_line.config(sender, timestamp, msg)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("chat_toggle"):
		get_node("/root/Anathema").ui = true
		line_edit.grab_focus()

func _on_line_edit_text_submitted(new_text: String) -> void:
	if line_edit.text != "":
		Server.client_to_server_new_chat_message(new_text)
		line_edit.clear()
		line_edit.release_focus()
		get_node("/root/Anathema").ui = false
