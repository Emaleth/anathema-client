extends Node


var login_scene := preload("res://login_register.tscn")
var world_scene := preload("res://world.tscn")

func _ready() -> void:
	add_child(login_scene.instantiate())
