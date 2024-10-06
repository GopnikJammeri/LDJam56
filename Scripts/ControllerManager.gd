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
	pass
	#add_child(PlayerHuman)
	#add_child(PlayerMosquito)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	pass
