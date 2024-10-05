extends Node

signal on_health_change()

var health: float = 100
@onready var timer = $Timer

func GetHealth() -> int:
	return health

func ReduceHealth(damage:float) -> void:
	health -= damage
	
	if health <= 0:
		get_tree().set_deferred("paused", true)
	
	emit_signal("on_health_change")

func _on_timer_timeout():
	get_tree().set_deferred("paused", true)

func reduce_time(time_to_reduce: float):
	if timer.time_left > time_to_reduce:
		var new_time_left = timer.time_left - time_to_reduce
		timer.start(new_time_left)
	else:
		timer.start(0.1)
