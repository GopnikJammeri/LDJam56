extends Node

class_name BaseController

var playerNumber = 0

func GetXAxis() -> int:
	push_error("Interface function not implemented")
	return 0

func GetYAxis() -> int:
	push_error("Interface function not implemented")
	return 0
	
func GetActionA() -> bool:
	push_error("Interface function not implemented")
	return false
	
func GetActionB() -> bool:
	push_error("Interface function not implemented")
	return false

var PlayerHuman: BaseController;
var PlayerMosquito: BaseController;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var connectedJoycons =  Input.get_connected_joypads().size()
	print("Connected joycons %d",connectedJoycons)
	if( connectedJoycons == 1 ):
		print("Mosquito using joystick")
		PlayerMosquito = JoyController.new()
		PlayerHuman = HumanMouseController.new()
	elif( connectedJoycons == 2 ):
		print("Both players using joysticks")
		PlayerMosquito = JoyController.new()
		PlayerHuman = JoyController.new()
		# change the controller to the second controller
		PlayerHuman.playerNumber = 1 
	else:
		print("Both players using keyboard & mouse")
		PlayerMosquito = MosquitoKeyboardController.new()
		PlayerHuman = HumanMouseController.new()
	#add_child(PlayerHuman)
	#add_child(PlayerMosquito)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	if(PlayerMosquito.GetActionA()):
		print("A button pressed")
	if(PlayerHuman.GetActionA()):
		print("Human clicked")
