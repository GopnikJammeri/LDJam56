extends CharacterBody2D

var pointer_position = Vector2.ZERO
var move_vector = Vector2.ZERO
var is_ready_to_attack = true

@export var move_speed = 200
@export var move_with_keys = true
var Mosquito = preload("res://Scenes/mosquito.tscn")

@onready var attack_cooldown = $AttackCooldown
@onready var collision_cooldown = $CollisionCooldown
@onready var hit_collision = $HitBox/CollisionShape2D
@onready var reach_area = $CollisionPolygon2D

func _ready():
	reach_area.top_level = true
	reach_area.position = position
	if(!move_with_keys):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _input(event):
	if(move_with_keys):
		return
	if event is InputEventMouseMotion:
		pointer_position = event.position
	
	#print(position.distance_to(get_global_mouse_position()))
	if position.distance_to(get_global_mouse_position()) > 50:
		get_viewport().warp_mouse(position + move_vector * 50)

func _physics_process(delta):
	var direction = Vector2()
	if Input.is_action_just_pressed("left_click") && is_ready_to_attack:
		is_ready_to_attack = false
		attack_cooldown.start()
		
		hit_collision.disabled = false
		collision_cooldown.start()
		
		#print("click")
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
	direction = direction.normalized() * move_speed
	velocity = direction
	move_and_slide()


func _on_attack_cooldown_timeout():
	is_ready_to_attack = true


func _on_collision_cooldown_timeout():
	hit_collision.disabled = true
