extends Node2D
signal mosquito_overlapped_start
signal mosquito_overlapped_end

func _on_area_2d_body_entered(_body: Node2D) -> void:
	emit_signal("mosquito_overlapped_start")

func _on_area_2d_body_exited(_body: Node2D) -> void:
	emit_signal("mosquito_overlapped_end")

func _process(_delta: float) -> void:
	position += Vector2(0.2,0.2)
