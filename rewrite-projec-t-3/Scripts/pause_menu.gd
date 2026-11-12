extends CanvasLayer

@onready var pause_panel: Control = %PausePanel
@onready var resume_button: Button = %ResumeButton
@onready var quit_button: Button = %QuitButton

@onready var background_music: AudioStreamPlayer = get_node("/root/BackgroundMusic")


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	pause_panel.hide()
	resume_button.pressed.connect(resume)
	quit_button.pressed.connect(_on_quit_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel"):
		if get_tree().paused:
			resume()
		else:
			pause()
		get_viewport().set_input_as_handled()

func pause() -> void:
	#stop music after pressing esc
	if is_instance_valid(background_music):
		background_music.stream_paused = true
	
	get_tree().paused = true
	pause_panel.show()
	resume_button.grab_focus()

func resume() -> void:
	get_tree().paused = false
	
	#resume music
	if is_instance_valid(background_music):
		background_music.stream_paused = false
		
	pause_panel.hide()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	BackgroundMusic.stop()
	get_tree().change_scene_to_file("res://Levels/main_menu.tscn")
