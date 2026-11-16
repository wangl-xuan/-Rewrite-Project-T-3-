extends Control

#typing speed
@export var type_speed : float = 0.07
@export var line_pause : float = 1.5
@export var lines: Array[String] = [
	"Your ship has crashed on a dead planet.",
	"No rescue. No signal. No way home.",
	"Far above the wasteland, a lone tower pierces the sky.",
	"Reach the summit. Restore the connection.",
	"Contact Headquarters. ",
	"Go home."
]
@export_file("*.tscn") var next_scene: String = "res://Levels/level_1.tscn"

@onready var story_label: Label = %StoryLabel

func _ready() -> void:
	for line in lines:
		await type_line(line)
		await get_tree().create_timer(line_pause).timeout
	
	#go to levels
	Globals.go_to_world(next_scene)

func type_line(line: String) ->void:
	story_label.text = line
	story_label.visible_ratio = 0.0
	
	var type_time := line.length() * type_speed
	var tween := create_tween()
	tween.tween_property(story_label, "visible_ratio", 1.0, type_time)
	await tween.finished
