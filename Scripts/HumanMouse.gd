extends BaseController

class_name HumanMouseController 

func GetXAxis() -> int:
	if(Input.is_key_pressed(KEY_LEFT)):
		return -1
	elif(Input.is_key_pressed(KEY_RIGHT)):
		return 1
	return 0

func GetYAxis() -> int:
	if(Input.is_key_pressed(KEY_DOWN)):
		return -1
	elif(Input.is_key_pressed(KEY_UP)):
		return 1
	return 0
	
func GetActionA() -> bool:
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		return true
	return false
	
func GetActionB() -> bool:
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)):
		return true
	return false
