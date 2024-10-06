extends Node2D
signal mosquito_overlapped_start
signal mosquito_overlapped_end

func _ready() -> void:
	pass
	#print(get_path())
func _on_hurt_box_area_entered(area: Area2D):
	if area.get_parent().name == "Mosquito":
		emit_signal("mosquito_overlapped_start", Globals.MosquitoPlace.FACE)
	

func _on_hurt_box_area_exited(area):
	if area.get_parent().name == "Mosquito":
		emit_signal("mosquito_overlapped_end", Globals.MosquitoPlace.FACE)
