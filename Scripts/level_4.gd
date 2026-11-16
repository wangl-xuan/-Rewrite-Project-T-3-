extends Node2D

@onready var prompt: Label = $InteractionUI/InteractionLabel
@onready var base_area: Area2D = $Base/Area2D
@onready var laser: AnimatedSprite2D = $AnimatedSprite2D

var player_near_base = false
var laser_activated = false

func _ready():
	prompt.hide()
	laser.hide()
	laser.stop()
	laser.frame = 0
	
	base_area.body_entered.connect(_on_base_entered)
	base_area.body_exited.connect(_on_base_exited)

func _process(_delta):
	if player_near_base and not laser_activated:
		if Input.is_action_just_pressed("use"):
			laser_activated = true
			prompt.hide()
			laser.show()
			laser.play("laser")
			
			await get_tree().create_timer(2.5).timeout
			Globals.go_to_world("res://Levels/end.tscn")

func _on_base_entered(body):
	if body.is_in_group("player"):
		player_near_base = true
		prompt.show()

func _on_base_exited(body):
	if body.is_in_group("player"):
		player_near_base = false
		prompt.hide()
