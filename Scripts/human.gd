extends Node2D
signal mosquito_overlapped_start
signal mosquito_overlapped_end


func _on_hurt_box_area_entered(area):
	emit_signal("mosquito_overlapped_start")

func _on_hurt_box_area_exited(area):
	emit_signal("mosquito_overlapped_end")
