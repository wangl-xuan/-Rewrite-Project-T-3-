extends Area2D

@export_file("*.tscn") var path: String

func _on_body_entered(body: Node2D) -> void:
	#freezing the character
	if body.is_in_group("player"):
		body.process_mode = Node.PROCESS_MODE_DISABLED
		Globals.go_to_world(path)
