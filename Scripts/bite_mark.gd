extends Node2D

var damage: float = 0.5
var scratches_left: int = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	StatsManager.ReduceHealth(damage * delta)


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Hands"):
		scratches_left -= 1
		if(scratches_left <= 0):
			queue_free()
		#print("Mark scratches left: ",scratches_left)
