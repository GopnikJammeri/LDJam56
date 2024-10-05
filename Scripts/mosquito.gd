extends CharacterBody2D

@export var speed: float = 500.0     # The forward movement speed
@export var rotation_speed: float = 10.0  # The speed of steering

var screen_size: Vector2 = Vector2.ZERO
var is_attached: bool = false
var can_move: bool = true
var is_on_human: bool = false

func _ready() -> void:
	screen_size = get_viewport_rect().size
	fetch_character()
	

func _physics_process(delta: float) -> void:
	
	if can_move:
		handle_movement(delta)
	handle_attack()
	move_and_slide()
	handle_screen_wrapping()
	
func handle_movement(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		rotation -= rotation_speed * delta
	elif Input.is_action_pressed("ui_right"):
		rotation += rotation_speed * delta
	
	var direction = Vector2(cos(rotation), sin(rotation))
	velocity = direction * speed
	

func handle_screen_wrapping() -> void:
	if position.x < 0:
		position.x = screen_size.x
	elif position.x > screen_size.x:
		position.x = 0
	
	if position.y < 0:
		position.y = screen_size.y
	elif position.y > screen_size.y:
		position.y = 0

func handle_attack() -> void:
	if Input.is_action_just_pressed("mosquito_attack"):
		print("attacl")
		if not is_attached:
			attach()
		else:
			detach()

func fetch_character() -> void:
	var world = get_tree().current_scene
	var human = world.get_node("Human")

func attach() -> void:
	velocity = Vector2.ZERO
	can_move = false
	is_attached = true
	
func detach() -> void:
	can_move = true
	is_attached = false
