extends CharacterBody2D

@export var speed: float =10.0

var player_ref: Player = null 

func _ready() -> void:
	player_ref = get_tree().get_first_node_in_group("player")
	
	
	

func _physics_process(delta: float) -> void:
	if player_ref == null:
		return

	
	

	if player_ref.current_terrain == Player.Terrain.GROUND:
		var direction = (player_ref.global_position - global_position).normalized()
		velocity = direction * speed
		
		if direction.x < 0:
			$Sprite2D.flip_h = true
		elif direction.x > 0:
			$Sprite2D.flip_h = false
			
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()
