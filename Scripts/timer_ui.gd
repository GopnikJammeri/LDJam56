extends Control

@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.text = "%02d:%02d" % time_left()


func time_left():
	var time_left =  StatsManager.timer.time_left
	var minute = floor(time_left / 60)
	var seconds = int(time_left) % 60
	return [minute, seconds]
