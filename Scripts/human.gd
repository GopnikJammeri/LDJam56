extends Node2D
signal mosquito_overlapped_start
signal mosquito_overlapped_end

func _on_area_2d_body_entered(body: Node2D) -> void:
	emit_signal("mosquito_overlapped_start")

func _on_area_2d_body_exited(body: Node2D) -> void:
	emit_signal("mosquito_overlapped_end")
