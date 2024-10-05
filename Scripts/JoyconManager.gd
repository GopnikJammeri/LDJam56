extends BaseController

class_name JoyController 

func GetXAxis() -> int:
	return Input.get_joy_axis(playerNumber,0)

func GetYAxis() -> int:
	return Input.get_joy_axis(playerNumber,1)
	
func GetActionA() -> bool:
	if(Input.is_joy_button_pressed(0,JOY_BUTTON_A)):
		return true
	return false
	
func GetActionB() -> bool:
	if(Input.is_joy_button_pressed(0,JOY_BUTTON_B)):
		return true
	return false
