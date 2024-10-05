extends Node2D

@onready var hand_right: Hand = $HandRight
@onready var hand_left: Hand = $HandLeft

var current_hand: Hand = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("EJEJE")
	set_active_hand(hand_right)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("switch_hand"):
		switch_hand()

func set_active_hand(hand: Hand) -> void:
	hand_right.active = false
	hand_left.active = false
	
	current_hand = hand
	current_hand.active = true
	
	print(hand_left.active)
	print(hand_right.active)
	print(current_hand.active)
	
func switch_hand() -> void:
	if current_hand == hand_left:
		set_active_hand(hand_right)
	elif current_hand == hand_right:
		set_active_hand(hand_left)
