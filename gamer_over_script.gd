extends Control

@onready var player_text: Label = $PlayerWonText
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(StatsManager.GetHealth()>0):
		player_text.text = "Mosquito won"
	else:
		player_text.text = "Human won"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
