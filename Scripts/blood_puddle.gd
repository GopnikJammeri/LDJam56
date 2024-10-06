extends Node2D

@onready var despawn_timer: Timer = $DespawnTimer
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer

func _ready() -> void:
	despawn_timer.start()

func _on_despawn_timer_timeout() -> void:
	animation_player.play("dissapear")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
