extends CharacterBody2D


@export var speed: float = 500.0     # The forward movement speed
@export var rotation_speed: float = 10.0  # The speed of steering

var screen_size: Vector2 = Vector2.ZERO
var sprite_size: Vector2 = Vector2.ZERO
var PlayerInput
func _ready() -> void:
	screen_size = get_viewport_rect().size
	var sprite: Sprite2D = $Sprite2D
	if sprite:
		sprite_size = sprite.texture.get_size()
		
	PlayerInput = ControllerManager.PlayerMosquito

func _physics_process(delta: float) -> void:
	if PlayerInput.GetXAxis() < 0:
		rotation -= rotation_speed * delta
	elif PlayerInput.GetXAxis() > 0:
		rotation += rotation_speed * delta
	#position += Vector2(cos(rotation), sin(rotation)) * speed * delta
	
	var direction = Vector2(cos(rotation), sin(rotation))
	velocity = direction * speed
	
	move_and_slide()
	handle_screen_wrapping()
	

func handle_screen_wrapping() -> void:
	var half_sprite_width = sprite_size.x / 2
	var half_sprite_height = sprite_size.y / 2
	
	if position.x < 0:
		position.x = screen_size.x
	elif position.x > screen_size.x:
		position.x = 0
	
	if position.y < 0:
		position.y = screen_size.y
	elif position.y > screen_size.y:
		position.y = 0
