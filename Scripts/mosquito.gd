extends CharacterBody2D

@export var speed: float = 500.0     # The forward movement speed
@export var rotation_speed: float = 10.0  # The speed of steering

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var bite_mark_timer: Timer = $BiteMarkTimer

const BITE_MARK = preload("res://Scenes/bite_mark.tscn")

var screen_size: Vector2 = Vector2.ZERO
var is_attached: bool = false
var can_move: bool = true
var is_on_human: bool = false
var is_on_cooldown: bool = false
var human = null
var attached_offset: Vector2 = Vector2.ZERO
var PlayerInput

func _ready() -> void:
	screen_size = get_viewport_rect().size
	fetch_character()
	PlayerInput = ControllerManager.PlayerMosquito
	
func _physics_process(delta: float) -> void:
	if can_move:
		handle_movement(delta)
	if is_on_human:
		handle_attack()
	if is_attached:
		position = human.position + attached_offset
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
		if not is_attached:
			attach()
		elif not is_on_cooldown:
			detach()

func fetch_character() -> void:
	var world = get_tree().current_scene
	var human_local = world.get_node("Human")
	human = human_local
	if human:
		human.connect("mosquito_overlapped_start", set_is_on_human)
		human.connect("mosquito_overlapped_end", deset_is_on_human)
	else:
		assert(human != null, "mosquito.gd : fetch_character : -Human not found in a scene-")
	
func attach() -> void:
	velocity = Vector2.ZERO
	can_move = false
	is_attached = true
	attached_offset = position - human.position
	is_on_cooldown = true
	cooldown_timer.start()
	bite_mark_timer.start()
	
func detach() -> void:
	can_move = true
	is_attached = false
	bite_mark_timer.stop()

func set_is_on_human():
	is_on_human = true
	
func deset_is_on_human():
	is_on_human = false

func _on_bite_mark_timer_timeout() -> void:
	var bite_mark = BITE_MARK.instantiate()
	bite_mark.position = position - human.position 
	human.add_child(bite_mark) 
	print("Bite mark spawned!")


func _on_cooldown_timer_timeout() -> void:
	print("Cooldown finished")
	is_on_cooldown = false
