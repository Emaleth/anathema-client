extends MeshInstance3D


func set_actor_name(actor_name : String):
	$SubViewport/PanelContainer/Label.text = actor_name

func _on_panel_container_resized() -> void:
	$SubViewport.size = $SubViewport/PanelContainer.size
