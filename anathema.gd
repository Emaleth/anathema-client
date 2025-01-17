extends Node

var ui = false
var login_scene := preload("res://login_register.tscn")
var world_scene := preload("res://world.tscn")
var current_scene = 0
var current_instance

func _ready() -> void:
	switch_scene()

func switch_scene():
	print("switching scenes")
	if current_instance: current_instance.queue_free()
	if current_scene == 0:
		current_instance = login_scene.instantiate()
		add_child(current_instance)
		current_scene = 1
	elif current_scene == 1:
		current_instance = world_scene.instantiate()
		add_child(current_instance)
		current_scene = 0
