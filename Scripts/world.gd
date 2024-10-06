extends Node2D

@onready var hand_right: Hand = $HandRight
@onready var hand_left: Hand = $HandLeft
@onready var main_camera: Camera2D = $MainCamera


var current_hand: Hand = null
var screen_size: Vector2 = Vector2.ZERO

func _ready() -> void:
	set_active_hand(hand_right)
	set_camera_dimensions()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("switch_hand"):
		switch_hand()

func set_active_hand(hand: Hand) -> void:
	hand_right.active = false
	hand_left.active = false
	
	current_hand = hand
	current_hand.active = true
	
func switch_hand() -> void:
	if current_hand == hand_left:
		set_active_hand(hand_right)
	elif current_hand == hand_right:
		set_active_hand(hand_left)

func set_camera_dimensions() -> void:
	main_camera.make_current()
	screen_size = get_viewport_rect().size
	main_camera.limit_left = 0
	main_camera.limit_right = screen_size.x
	main_camera.limit_top = 0
	main_camera.limit_bottom = screen_size.y
