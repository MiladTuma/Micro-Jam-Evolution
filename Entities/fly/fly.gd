extends CharacterBody2D

@export var speed: float = 100.0
@export var flee_speed: float = 25.0


var is_fleeing: bool = false
var player_ref: Node2D = null 

func _ready() -> void:
	add_to_group("flies") 
	%AnimatedSprite2D.play()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player": 
		is_fleeing = true
		player_ref = body 

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_fleeing = false
		player_ref = null 

func _physics_process(delta: float) -> void:
	
	if is_fleeing and player_ref != null:
		
		
		var flee_direction = (global_position - player_ref.global_position).normalized()
		
		velocity = flee_direction * flee_speed
		
		
		
	else:
		
		velocity = Vector2.ZERO
		
	move_and_slide()


func get_eaten() -> void:
	
	queue_free() 
