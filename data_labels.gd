extends CanvasLayer

@export var player : CharacterBody2D
@export var data_text : Label

func _process(_delta: float) -> void:
	data_text.text = "Health: " + str(snappedf(player.current_health, 0.1))
	data_text.text +=  "\nGround Speed: " + str(snappedf(player.GROUNDSPEED, 0.1))
	data_text.text +=  "\nSwimming Speed: " + str(snappedf(player.SWIMMINGSPEED, 0.1))
	data_text.text +=  "\nPoison Resistance: " + str(player.poison_resistance)
