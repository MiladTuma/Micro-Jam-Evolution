extends CharacterBody2D

@export var speed: float = 100.0
@export var flee_speed: float = 25.0 

var is_fleeing: bool = false
var flee_direction: Vector2 = Vector2.ZERO

func _ready():
	%AnimatedSprite2D.play()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player": 
		is_fleeing = true
		
		flee_direction = (global_position - body.global_position).normalized()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_fleeing = false

func _physics_process(delta: float) -> void:
	if is_fleeing:
		
		velocity = flee_direction * flee_speed
	else:
		
		velocity = Vector2.ZERO 
		
	
	move_and_slide()
