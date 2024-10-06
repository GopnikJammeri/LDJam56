extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/loading_screen.tscn")

func _on_quit_pressed():
	get_tree().quit()


func _on_rules_and_controls_pressed():
		get_tree().change_scene_to_file("res://Scenes/rules_and_controles.tscn")
