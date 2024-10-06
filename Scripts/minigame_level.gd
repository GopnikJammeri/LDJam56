extends Node2D

const NUM_OF_PORTALS: int = 8
const BRAIN_TELEPORTER = preload("res://Scenes/brain_teleporter.tscn")

@onready var minigame_camera: Camera2D = $MinigameCamera

var portals = []
var portal_pairs = {}
var children_number: int
var special_portal = null
var screen_size: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_camera_dimensions()
	children_number = get_node("Teleporters").get_children().size()
	
	for i in range (children_number):
		var portal = get_node("Teleporters").get_child(i)
		portal.name = "Portal_%d" % i
		portal.set_meta("portal_id", i)
		portal.index = i
		portals.append(portal)
		portal.connect("mosquito_entered_portal", _handle_teleportation)
	_pair_portals()

func _pair_portals() -> void:
	var indices = range(children_number)
	indices.shuffle()
	
	for i in range(0, children_number, 2):
		var portal_a = portals[indices[i]]
		var portal_b = portals[indices[i + 1]]
		
		portal_pairs[portal_a.index] = portal_b
		portal_pairs[portal_b.index] = portal_a
		
	special_portal = indices[0]  # Or any other logic to choose a portal
	print("Special portal is: ", special_portal)

func _handle_teleportation(index: int) -> void:
	print(index)
	
	if index == special_portal:
		handle_special_portal()
		return
	
	var paired_portal = portal_pairs[index] 
	var new_position = paired_portal.position + paired_portal.spawn_point
	new_position = paired_portal.spawner.global_position
	
	# Move the mosquito to the paired portal's global position
	var mosquito = get_tree().current_scene.get_node("Mosquito")
	mosquito.global_position = new_position
	
	# Calculate direction vector from the portal to the new position
	var direction_away = (mosquito.global_position - paired_portal.global_position).normalized()
	
	mosquito.rotation = direction_away.angle()
	mosquito.velocity = direction_away * mosquito.speed
	

func handle_special_portal() -> void:
	var main_camera = get_node("../MainCamera")
	var mosquito = get_node("../Mosquito")
	Globals.can_human_move = true
	
	if main_camera:
		main_camera.make_current()  # Set the main camera as the active camera
	else:
		print("Error: Main camera not found")
	
	if mosquito:
		mosquito.position = get_node("../MosquitoSpawnPoint").position
		mosquito.current_camera = main_camera
		mosquito.position = $"../MosquitoSpawnPoint".position
		print( $"../MosquitoSpawnPoint".position)
	else:
		print("Error: Mosquito node not found")

func set_camera_dimensions() -> void:
	screen_size = get_viewport_rect().size
	minigame_camera.position = Vector2(screen_size.x / 2, screen_size.y / 2)
