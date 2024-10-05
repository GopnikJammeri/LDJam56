extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var velocity = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	print(Input.get_joy_axis(0, 0))
	if(Input.is_joy_button_pressed(0,JOY_BUTTON_A)):
		print("A pressed")
