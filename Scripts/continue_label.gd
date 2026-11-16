extends Label

func _ready() -> void:
	var t := create_tween().set_loops()
	t.tween_property(self, "modulate:a", 0.25, 0.8)
	t.tween_property(self, "modulate:a", 1.0, 0.8)
