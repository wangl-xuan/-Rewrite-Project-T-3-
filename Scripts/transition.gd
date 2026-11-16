extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

#transition to next
func _ready() -> void:
	$fade.modulate.a = 0.0

#screen goes black
func fade_out() -> void:
	animation_player.play_backwards("fade_in")
	await animation_player.animation_finished

#screen comes back
func fade_in() -> void:
	animation_player.play("fade_in")

func go_to_world(path: String) -> void:
	await fade_out()
	
	#go to next level
	get_tree().change_scene_to_file(path)
	fade_in()
