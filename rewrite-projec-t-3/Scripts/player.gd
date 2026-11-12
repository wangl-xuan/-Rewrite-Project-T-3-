extends CharacterBody2D

@export var SPEED: float = 300.0
@export var JUMP_VELOCITY: float = -400.0
@export var JUMP_AUDIO_VOLUME_DB: float = -10
@export var WALK_AUDIO_VOLUME_DB: float = -10
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var walk_audio_stream_player: AudioStreamPlayer = $WalkAudioStreamPlayer
@onready var jump_animation_player: AnimationPlayer = $JumpAnimationPlayer
@onready var jump_audio_stream_player: AudioStreamPlayer = $JumpAudioStreamPlayer

var jumping: bool = true
var spawn_position: Vector2
var is_dead : bool = false

var phase_animation_active: bool = false
var rewind_animation_active: bool = false

func _ready() -> void:
	jump_audio_stream_player.volume_db = JUMP_AUDIO_VOLUME_DB
	walk_audio_stream_player.volume_db = WALK_AUDIO_VOLUME_DB
	
	#get player position
	add_to_group("player")
	spawn_position = global_position

func _physics_process(delta: float) -> void:
	
	if (!is_on_floor()):
		velocity += get_gravity() * delta
		jumping = true
	
	elif (jumping):
		jumping = false
		
		#jump falling animation
		jump_animation_player.play("end")
	
	if Input.is_action_just_pressed("jump") && is_on_floor():
		
		velocity.y = JUMP_VELOCITY
		
		#jump start animation
		jump_animation_player.play("start")
		jump_audio_stream_player.play()
	
	var direction : float = Input.get_axis("left", "right")
	
	
	#animation flip
	if (direction > 0):
		
		animated_sprite_2d.flip_h = false
		
	elif (direction < 0):
		
		animated_sprite_2d.flip_h = true
	
	#horizontal speed
	if (direction):
		
		velocity.x = direction * SPEED
		
	else:
		
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	
	if (direction && is_on_floor()):
		
		#play walk sounds
		if (!walk_audio_stream_player.playing):
			walk_audio_stream_player.play()
			
		#play run animation unless the skill animation is active
		if not phase_animation_active and not rewind_animation_active:
			animated_sprite_2d.play("walk")
	
	else:
		
		#play idel animation unless the skill animation is active
		if not phase_animation_active and not rewind_animation_active:
			animated_sprite_2d.play("idle")
			
	move_and_slide()

#respawn
func respawn() -> void:
	global_position = spawn_position
	velocity = Vector2.ZERO
	$Rewind.history.clear()

#freezing and playing death animation
func die() -> void:
	if is_dead:
		return
	is_dead = true
	
	#freeze the player
	set_physics_process(false)
	$Rewind.set_physics_process(false)
	$Phase.set_physics_process(false)
	animated_sprite_2d.play("death")
	
	#screen transition
	await Globals.fade_out()
	respawn()
	Globals.fade_in()
	
	#unfreeze
	set_physics_process(true)
	$Rewind.set_physics_process(true)
	$Phase.set_physics_process(true)
	is_dead = false
