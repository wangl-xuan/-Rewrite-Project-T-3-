extends Control

func _input(event):
	if event.is_pressed() and not event.is_echo():
		set_process_input(false)
		Globals.go_to_world("res://Levels/main_menu.tscn")
