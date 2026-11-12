extends Node

@export var rewind_time : float = 2.0
@export var cooldown: float = 9.0
@export var animation_time: float = 0.8

@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var player: CharacterBody2D = get_parent()

#remember player's position
var history: Array[Vector2] = []

#seconds since the last rewind
var time_since_rewind = 999.0

func _physics_process(delta: float) -> void:
	time_since_rewind += delta
	
	save_position()
	
	if Input.is_action_just_pressed("rewind") && time_since_rewind >= cooldown:
		rewind()
		
	play_animation()

#save player's position
func save_position() -> void:
	history.append(player.global_position)
	
	var max_count := int(rewind_time * Engine.physics_ticks_per_second)
	while history.size() > max_count:
		history.pop_front()

#go back to the oldest saved position
func rewind() -> void:
	player.global_position = history[0]
	player.velocity = Vector2.ZERO
	history.clear()
	time_since_rewind = 0.0

#show the rewind animation
func play_animation() -> void:
	if time_since_rewind >= animation_time:
		return
	
	var frame_count := sprite.sprite_frames.get_frame_count("rewind")
	sprite.animation = "rewind"
	sprite.frame = int(time_since_rewind / animation_time * frame_count)
