extends PanelContainer


@onready var center_container := $CenterContainer

@onready var login_scene := preload("res://login.tscn")
@onready var register_scene := preload("res://register.tscn")

func _ready() -> void:
	load_login_scene()


func load_login_scene():
	for i in center_container.get_children():
		i.queue_free()
	var ls := login_scene.instantiate()
	center_container.add_child(ls)
	ls.register_button.pressed.connect(load_register_scene)


func load_register_scene():
	for i in center_container.get_children():
		i.queue_free()
	var rs := register_scene.instantiate()
	center_container.add_child(rs)
	rs.login_button.pressed.connect(load_login_scene)
