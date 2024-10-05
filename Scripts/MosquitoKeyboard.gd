extends BaseController

class_name MosquitoKeyboardController 

func GetXAxis() -> int:
	if(Input.is_key_pressed(KEY_A)):
		return -1
	elif(Input.is_key_pressed(KEY_D)):
		return 1
	return 0

func GetYAxis() -> int:
	return 0
	
func GetActionA() -> bool:
	if(Input.is_key_pressed(KEY_W)):
		return true
	return false
	
func GetActionB() -> bool:
	if(Input.is_key_pressed(KEY_S)):
		return true
	return false
