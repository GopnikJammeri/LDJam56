extends Node2D

@onready var hand_right: Hand = $HandRight
@onready var hand_left: Hand = $HandLeft

var current_hand: Hand = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_active_hand(hand_right)

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
