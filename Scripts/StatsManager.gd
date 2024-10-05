extends Node

signal on_health_change()

var health: float = 100
@onready var timer = $Timer

func GetHealth() -> int:
	return health

func ReduceHealth(damage:float) -> void:
	health -= damage
	emit_signal("on_health_change")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout():
	get_tree().set_deferred("paused", true)
