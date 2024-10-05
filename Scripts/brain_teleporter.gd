extends Node2D

signal mosquito_entered_portal(portal_index: int)
@export var index: int
@export var spawn_point: Vector2

@onready var spawner: Node2D = $Spawner

func _ready() -> void:
	spawn_point = spawner.position

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("ENTER")
	emit_signal("mosquito_entered_portal", index)
