extends ProgressBar

#signal on_damaged(damage_amount)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = StatsManager.GetHealth()
	StatsManager.connect("on_health_change",_on_health_changed)


func _on_health_changed() -> void:
	value = StatsManager.GetHealth()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
