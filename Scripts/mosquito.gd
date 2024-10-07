extends CharacterBody2D

@export var speed_in_world: float = 450.0     # The forward movement speed
@export var speed_in_minigame: float = 300.0     # The forward movement speed
@export var rotation_speed_in_world: float = 10.0  # The speed of steering
@export var rotation_speed_in_minigame: float = 7.0  # The speed of steering
@export var damage: int = 3


@onready var cooldown_timer: Timer = $CooldownTimer
@onready var bite_mark_timer: Timer = $BiteMarkTimer
@onready var respawn_timer: Timer = $RespawnTimer
@onready var animation_tree: AnimationTree = $MosquitoSprite/AnimationTree
@onready var mosquito_spawn_point_minigame: Node2D = $"../MinigameLevel/MosquitoSpawnPoint2"
@onready var main_camera: Camera2D = $"../MainCamera"
@onready var minigame_camera: Camera2D = $"../MinigameLevel/MinigameCamera"
@onready var mosquito_sprite = $MosquitoSprite
@onready var move_direction_sprite = $MoveDirectionSprite
@onready var nodeLeftEar = get_node("/root/World/Human/HitBoxLeft/CollisionLeftEar")
@onready var nodeRightEar = get_node("/root/World/Human/HitBoxRight/CollisionRightEar")
@onready var head_pass_trough_timer = $HeadPassTroughTimer

const BITE_MARK = preload("res://Scenes/bite_mark.tscn")
const MINIGAME_LEVEL = preload("res://Scenes/minigame_level.tscn")
const BLOOD_PUDDLE = preload("res://Scenes/blood_puddle.tscn")
const MOSQUITO = preload("res://Scenes/mosquito.tscn")
const TIME_REDUCTION: float = 30.0

var speed: float = 450
var rotation_speed: float = 10.0
var screen_size: Vector2 = Vector2.ZERO
var is_attached: bool = false
var can_move: bool = true
var is_on_human: bool = false
var is_on_cooldown: bool = false
var human = null
var hand_left = null
var hand_right = null
var attached_offset: Vector2 = Vector2.ZERO
var bite_threshold: float = 20.0
var attached_to: Globals.MosquitoPlace = Globals.MosquitoPlace.NONE
var position_of_human: Vector2 = Vector2.ZERO
var spawn_point = null
var is_in_minigame: bool = false
var current_camera: Camera2D
var position_of_ear
var rotation_of_ear


func _ready() -> void:
	screen_size = get_viewport_rect().size
	current_camera = main_camera
	set_camera_dimensions()
	fetch_character()
	position = spawn_point.position
	

func _physics_process(delta: float) -> void:
	
	if abs(rotation) > 1.5 :
		mosquito_sprite.flip_v = true
	else:
		mosquito_sprite.flip_v = false
	
	
	handle_human_position() 
	if can_move:
		handle_movement(delta)
	if is_on_human:
		handle_attack()
	if is_attached:
		handle_attached_position()
		StatsManager.ReduceHealth(damage * delta)
	else:
		move_and_slide()
		handle_screen_wrapping()
	
func handle_movement(delta: float) -> void:
	if Input.is_action_pressed("mosquito_move_left"):
		rotation -= rotation_speed * delta
	elif Input.is_action_pressed("mosquito_move_right"):
		rotation += rotation_speed * delta
	
	var direction = Vector2(cos(rotation), sin(rotation))
	velocity = direction * speed
	
	move_direction_sprite.global_position = position + direction * 50
	move_direction_sprite.rotation = deg_to_rad(direction.angle() + 90) 

func handle_screen_wrapping() -> void:
	
	var viewport_size = current_camera.get_viewport_rect().size

	var left_edge = current_camera.global_position.x - viewport_size.x / 2
	var right_edge = current_camera.global_position.x + viewport_size.x / 2
	var top_edge = current_camera.global_position.y - viewport_size.y / 2
	var bottom_edge = current_camera.global_position.y + viewport_size.y / 2

	if position.x < left_edge:
		position.x = right_edge
	elif position.x > right_edge:
		position.x = left_edge

	if position.y < top_edge:
		position.y = bottom_edge
	elif position.y > bottom_edge:
		position.y = top_edge

func handle_attack() -> void:
	if Input.is_action_just_pressed("mosquito_attack"):
		if not is_attached:
			attach()
		elif not is_on_cooldown:
			detach()
			
	# Move to detach		
	var moved = Input.is_action_just_pressed("mosquito_move_left") or Input.is_action_just_pressed("mosquito_move_right")
	if(is_attached and moved and not is_on_cooldown):
		detach()
	
func handle_attached_position() -> void:
	position = position_of_human + attached_offset
		
func fetch_character() -> void:
	var world = get_tree().current_scene
	var human_local = world.get_node("Human")
	var hand_right_local = world.get_node("HandRight")
	var hand_left_local = world.get_node("HandLeft")
	spawn_point = world.get_node("MosquitoSpawnPoint")
	hand_right = hand_right_local
	hand_left = hand_left_local
	human = human_local
	
	if human:
		human.connect("mosquito_overlapped_start", set_is_on_human)
		human.connect("mosquito_overlapped_end", deset_is_on_human)
		hand_right.connect("mosquito_overlapped_start", set_is_on_human)
		hand_right.connect("mosquito_overlapped_end", deset_is_on_human)
		hand_left.connect("mosquito_overlapped_start", set_is_on_human)
		hand_left.connect("mosquito_overlapped_end", deset_is_on_human)
	else:
		#assert(human != null, "mosquito.gd : fetch_character : -Human not found in a scene-")
		pass
		
func attach() -> void:
	animation_tree["parameters/conditions/succ"] = true
	animation_tree["parameters/conditions/stopsucc"] = false
	velocity = Vector2.ZERO
	can_move = false
	is_attached = true
	attached_offset = position - position_of_human
	is_on_cooldown = true
	cooldown_timer.start()
	bite_mark_timer.start()
	
func detach() -> void:
	animation_tree["parameters/conditions/succ"] = false
	animation_tree["parameters/conditions/stopsucc"] = true
	can_move = true
	is_attached = false
	bite_mark_timer.stop()

func set_is_on_human(side: Globals.MosquitoPlace):
	if attached_to != Globals.MosquitoPlace.NONE:
		return
	attached_to = side
	is_on_human = true
	
func deset_is_on_human(side: Globals.MosquitoPlace):
	if not can_move:
		return
	
	attached_to = Globals.MosquitoPlace.NONE
	is_on_human = false

func _on_bite_mark_timer_timeout() -> void:
	if is_bite_mark_overlapped():
		return
		
	var bite_mark = BITE_MARK.instantiate()
	
	bite_mark.set_meta("bite_mark", true)
	
	match attached_to:
		Globals.MosquitoPlace.LEFT:
			hand_left.add_child(bite_mark)
		Globals.MosquitoPlace.RIGHT:
			hand_right.add_child(bite_mark)
		Globals.MosquitoPlace.FACE:
			human.add_child(bite_mark) 
	bite_mark.global_position = get_global_position()
	#print("Bite mark spawned!")

func _on_cooldown_timer_timeout() -> void:
	#print("Cooldown finished")
	is_on_cooldown = false

func _on_hurt_box_area_entered(area: Area2D):
	if(area.is_in_group("Hands")):
		#print("mosquito hit")
		handle_death()

func is_bite_mark_overlapped() -> bool:
	for child in human.get_children():
		if child.has_meta("bite_mark"):
			var distance = child.position.distance_to(position - human.position)
			if distance < bite_threshold:
				#print("Too close to another bite mark, won't spawn a new one.")
				return true
	for child in hand_left.get_children():
		if child.has_meta("bite_mark"):
			var distance = child.position.distance_to(position - human.position)
			if distance < bite_threshold:
				#print("Too close to another bite mark, won't spawn a new one.")
				return true
	for child in hand_right.get_children():
		if child.has_meta("bite_mark"):
			var distance = child.position.distance_to(position - human.position)
			if distance < bite_threshold:
				#print("Too close to another bite mark, won't spawn a new one.")
				return true
	return false

	
func handle_human_position() -> void:
	if attached_to == Globals.MosquitoPlace.LEFT:
		position_of_human = hand_left.position
	elif attached_to == Globals.MosquitoPlace.RIGHT:
		position_of_human = hand_right.position
	elif attached_to == Globals.MosquitoPlace.FACE:
		position_of_human = human.position

	
func _on_hit_box_area_entered(area: Area2D) -> void: 
	if area.is_in_group("Ears"):
		if nodeLeftEar != null and nodeRightEar != null:
			if !Input.is_action_pressed("mosquito_attack"):
				return
			
			if Globals.ears_plugged[0] == true or Globals.ears_plugged[1] == true:
				_spawn_minigame()
				return
			
			#entered left ear
			if(position.distance_to(nodeLeftEar.get_global_position()) > position.distance_to(nodeRightEar.get_global_position())):
				position_of_ear = nodeLeftEar.get_global_position() + Vector2(-40,0)
				rotation_of_ear = deg_to_rad(180)
			#entered right ear
			else:
				position_of_ear = nodeRightEar.get_global_position() + Vector2(40,0)
				rotation_of_ear = deg_to_rad(0)
			
			position = Vector2(1, 1)
			velocity = Vector2.ZERO
			can_move = false
			mosquito_sprite.visible = false
			move_direction_sprite.visible = false
			head_pass_trough_timer.start()
			
		else:
			print("One of the ears collisions is null")	
	if area.is_in_group("Plucked"):
		print("Entered the plucked")
		if (Globals.ears_plugged[0] or Globals.ears_plugged[1]) and not (Globals.ears_plugged[0] and Globals.ears_plugged[1]):
			print(Globals.ears_plugged)
		
func handle_death():
	cooldown_timer.stop()
	attached_to = Globals.MosquitoPlace.NONE
	spawn_blood_puddle()
	
	visible = false
	if is_attached:
		detach()
	can_move = false
	position = spawn_point.position
	respawn_timer.start()
	velocity = Vector2.ZERO
	StatsManager.add_health(10)

func _spawn_minigame() -> void:
	position = mosquito_spawn_point_minigame.global_position
	#print(position, mosquito_spawn_point_minigame.global_position)
	is_in_minigame = true
	current_camera = minigame_camera
	minigame_camera.make_current()
	Globals.can_human_move = false
	speed = speed_in_minigame
	rotation_speed = rotation_speed_in_minigame

func _transition_to_minigame() -> void:
	get_tree().change_scene_to_packed(MINIGAME_LEVEL)

func set_camera_dimensions() -> void:
	screen_size = get_viewport_rect().size
	main_camera.position = Vector2(screen_size.x / 2, screen_size.y / 2)

func _on_respawn_timer_timeout() -> void:
	can_move = true
	is_on_human = false
	visible = true


func spawn_blood_puddle() -> void:
	var blood_puddle = BLOOD_PUDDLE.instantiate()
	blood_puddle.global_position = global_position  # Set to mosquito's current position
	get_parent().add_child(blood_puddle)  # Add blood puddle to the parent node
	

func _on_head_pass_trough_timer_timeout():
	if Globals.ears_plugged[0] == true or Globals.ears_plugged[1] == true:
		move_direction_sprite.visible = true
		mosquito_sprite.visible = true
		can_move = true
		_spawn_minigame()
		return
	
	StatsManager.ReduceHealth(15)
	move_direction_sprite.visible = true
	mosquito_sprite.visible = true
	can_move = true
	position = position_of_ear
	rotation = rotation_of_ear
