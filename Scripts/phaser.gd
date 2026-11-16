extends Node

@export var phase_time: float = 3.0
@export var cooldown_time: float = 5.0

@onready var player: CharacterBody2D = get_parent()
@onready var animated_sprite_2d: AnimatedSprite2D = player.get_node("Anchor/AnimatedSprite2D")

var time_since_phase: float = 999.0

func _ready() -> void:
	# Listen for animation completion
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	
	#checking whether the player was phasing before this frame
	var was_phasing := time_since_phase <= phase_time
	
	time_since_phase += delta
	
	#skill activation
	if Input.is_action_just_pressed("phase") && time_since_phase >= phase_time + cooldown_time:
		time_since_phase = 0.0
		play_phase_animation()
	
	#skill ending
	elif was_phasing and time_since_phase > phase_time:
		play_phase_animation()
	
	update_layer()

#playing phse animation
func play_phase_animation() -> void:
	player.phase_animation_active = true
	animated_sprite_2d.play("phase")

func _on_animation_finished() -> void:
	if animated_sprite_2d.animation == "phase":
		player.phase_animation_active = false

func update_layer() -> void:
	var phasing := time_since_phase <= phase_time
	player.set_collision_layer_value(3,!phasing)
