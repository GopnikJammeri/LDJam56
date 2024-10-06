extends Node2D

@onready var despawn_timer: Timer = $DespawnTimer


func _ready() -> void:
	despawn_timer.start()
	pass


func _on_despawn_timer_timeout() -> void:
	queue_free()
