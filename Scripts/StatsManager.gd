extends Node

signal on_health_change()

var health: float = 100
@onready var timer = $Timer
var game_over_scene = "res://Scenes/game_over_scene.tscn"
func GetHealth() -> int:
	return health

func ReduceHealth(damage:float) -> void:
	health -= damage
	
	if health <= 0:
		get_tree().change_scene_to_file(game_over_scene)
	
	emit_signal("on_health_change")

func add_health(value: float) -> void:
	health = clamp(health + value, 0, 100) 
	emit_signal("on_health_change")

func reset_stats() -> void:
	health = 100
	emit_signal("on_health_change")
	timer.start()
	timer.paused = false

func _on_timer_timeout():
	get_tree().change_scene_to_file(game_over_scene)
	timer.start()
	timer.paused = true

func _input(event: InputEvent) -> void:
	# Check if the "F" key is pressed
	if event is InputEventKey and event.pressed and event.keycode == KEY_F:
		var fullscreen = DisplayServer.window_get_mode()
		if(!fullscreen == DisplayServer.WINDOW_MODE_FULLSCREEN):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) 
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED) 
#func reduce_time(time_to_reduce: float):
	#if timer.time_left > time_to_reduce:
		#var new_time_left = timer.time_left - time_to_reduce
		#timer.start(new_time_left)
	#else:
		#timer.start(0.1)
