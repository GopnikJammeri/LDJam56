extends CharacterBody2D

class_name Hand

signal mosquito_overlapped_end(side: Side)
signal mosquito_overlapped_start(side: Side)



var pointer_position = Vector2.ZERO
var move_vector = Vector2.ZERO
var is_ready_to_attack = true
var active: bool = false 
var move_speed

@export var move_speed_fast = 300
@export var move_speed_slow = 30
@export var move_with_keys: bool = true
@export var is_active: bool = true
@export var side: Globals.MosquitoPlace
const Mosquito = preload("res://Scenes/mosquito.tscn")

@onready var attack_cooldown = $AttackCooldown
@onready var collision_cooldown = $CollisionCooldown
@onready var hit_collision = $HitBox/CollisionShape2D
@onready var reach_area = $CollisionPolygon2D
@onready var animation_tree: AnimationTree = $SpriteHand/AnimationTree
@onready var animation_state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

func _ready():
	move_speed = move_speed_fast
	reach_area.top_level = true
	reach_area.position = position
	if !move_with_keys:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	print(active)
	animation_tree.active = true
	animation_tree["parameters/conditions/selectedHand"] = active
	

func _input(event):
	if move_with_keys:
		return
	if event is InputEventMouseMotion:
		pointer_position = event.position
	
	#print(position.distance_to(get_global_mouse_position()))
	if position.distance_to(get_global_mouse_position()) > 50:
		get_viewport().warp_mouse(position + move_vector * 50)

func _physics_process(delta):
	
	if not active:
		return
	if not Globals.can_human_move:
		return
	
	var direction = Vector2()
	if Input.is_action_just_pressed("left_click") && is_ready_to_attack:
		#print("SLAP")
		is_ready_to_attack = false
		attack_cooldown.start()
		
		hit_collision.disabled = false
		collision_cooldown.start()
		animation_state_machine.travel("hand_grab_air")
	
	if Geometry2D.is_point_in_polygon(reach_area.to_local(position), reach_area.polygon):
		move_speed = move_speed_fast
	else:
		if (position + move_vector).distance_to(reach_area.position) < position.distance_to(reach_area.position):
			move_speed = move_speed_fast
		else:
			move_speed = move_speed_slow
	
	if Input.is_action_pressed("human_move_left"):
		direction.x = -1
	if Input.is_action_pressed("human_move_right"):
		direction.x = 1
	if Input.is_action_pressed("human_move_down"):
		direction.y = 1
	if Input.is_action_pressed("human_move_up"):
		direction.y = -1
	
	if(!move_with_keys):
		move_vector = (pointer_position - position).normalized()
		position += move_vector * delta * move_speed
	
	move_vector = direction.normalized()
	direction = direction.normalized() * move_speed
	velocity = direction
	move_and_slide()

func _on_attack_cooldown_timeout():
	is_ready_to_attack = true

func _on_collision_cooldown_timeout():
	hit_collision.disabled = true

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "Mosquito":
		emit_signal("mosquito_overlapped_start", side)
	
	if(area.is_in_group("Bite")):
		animation_state_machine.travel("hand_scratch_transition")
		print("HAND ON BITE MARK")
	
	if( area.is_in_group("Ears")):
		Globals.ears_plugged[side] = true
		area.add_to_group("Plucked")
		area.remove_from_group("Ears")
		animation_tree["parameters/conditions/unplucked"] = false
		animation_tree["parameters/conditions/plucked"] = true
		#animation_state_machine.travel("hand_plug_ear")

func _on_hurt_box_area_exited(area: Area2D) -> void:
	emit_signal("mosquito_overlapped_end", side)
	if( area.is_in_group("Plucked")):
		animation_tree["parameters/conditions/unplucked"] = true
		animation_tree["parameters/conditions/plucked"] = false
		Globals.ears_plugged[side] = false
		area.add_to_group("Ears")
		area.remove_from_group("Plucked")
	
		
func activateHand(state: bool):
	active = state

	animation_tree["parameters/conditions/selectedHand"] = state
	animation_tree["parameters/conditions/deselectedHand"] = !state
