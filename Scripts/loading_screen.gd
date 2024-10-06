extends Node2D

var progress = []
var scene_name
var scene_load_status = 0
var dot_count: int = 0
var speed: float = 0.8

@onready var label: Label = $Label
@onready var animated_sprite_2d: AnimatedSprite2D = $Path2D/PathFollow2D/AnimatedSprite2D
@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D


func _ready():
	scene_name = "res://Scenes/world.tscn"
	ResourceLoader.load_threaded_request(scene_name)

func _process(delta):
	scene_load_status = ResourceLoader.load_threaded_get_status(scene_name, progress)

	path_follow_2d.progress_ratio += delta * speed

	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var new_scene = ResourceLoader.load_threaded_get(scene_name)
		get_tree().change_scene_to_packed(new_scene)

func _on_loading_dots_timer_timeout() -> void:
	dot_count = (dot_count + 1) % 4  # Cycle between 0 and 3
	label.text = "Loading"
	
	for i in range(dot_count):
		label.text += "."
	
	if dot_count == 0:
		label.text = "Loading"
