extends Control

var mousquito_cursor = load("res://Assets/mouse_cursor.png")

func _ready() -> void:
	Input.set_custom_mouse_cursor(mousquito_cursor)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/loading_screen.tscn")
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN 

func _on_quit_pressed():
	get_tree().quit()


func _on_rules_and_controls_pressed():
		get_tree().change_scene_to_file("res://Scenes/rules_and_controles.tscn")
