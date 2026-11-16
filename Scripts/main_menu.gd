extends Control

const INTRO_SCENE := "res://Levels/intro.tscn"

@onready var start_button: Button = %StartButton
@onready var credits_button: Button = %CreditsButton
@onready var quit_button: Button = %QuitButton
@onready var back_button: Button = %BackButton
@onready var settings_button: Button = %SettingsButton
@onready var settings_back_button: Button = %SettingsBackButton
@onready var menu_box: Control = %MenuBox
@onready var credits_panel: Control = %CreditsPanel
@onready var settings_panel: Control = %SettingsPanel

func _ready() -> void:
	credits_panel.hide()
	settings_panel.hide()
	start_button.pressed.connect(_on_start_pressed)
	credits_button.pressed.connect(_on_credits_pressed)
	quit_button.pressed.connect(get_tree().quit)
	back_button.pressed.connect(_on_back_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	settings_back_button.pressed.connect(_on_back_pressed)
	start_button.grab_focus()

func _on_start_pressed() -> void:
	Globals.go_to_world(INTRO_SCENE)

func _on_credits_pressed() -> void:
	menu_box.hide()
	credits_panel.show()
	back_button.grab_focus()

func _on_back_pressed() -> void:
	credits_panel.hide()
	settings_panel.hide()
	menu_box.show()
	start_button.grab_focus()

func _on_settings_pressed() -> void:
	menu_box.hide()
	settings_panel.show()
