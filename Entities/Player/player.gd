extends CharacterBody2D

# Variablen die wir ändern könnten für Evolution
var SPEED : int = 100
var SWIMMINGSPEED : int = 50



func _physics_process(_delta: float) -> void:
	var input_vector := Input.get_vector("left", "right", "up", "down")
	
	velocity = input_vector * SPEED
	move_and_slide()
