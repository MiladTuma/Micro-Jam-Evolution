extends CharacterBody2D

@export var speed: float = 5.0
@export var damage: int = 45
@export var tile_map: TileMapLayer

var player_ref: Player = null 

func _ready() -> void:
	add_to_group("snakes")
	player_ref = get_tree().get_first_node_in_group("player")

func _physics_process(_delta: float) -> void:
	if player_ref == null:
		return

	if player_ref.current_terrain == Player.Terrain.GROUND:
		var direction = (player_ref.global_position - global_position).normalized()
		
		var look_ahead_pos = global_position + (direction * 15.0) 
		var cell = tile_map.local_to_map(tile_map.to_local(look_ahead_pos))
		var tile_data = tile_map.get_cell_tile_data(cell)
		
		var is_water_ahead = false
		if tile_data != null:
			if tile_data.get_custom_data("terrain") == 1:
				is_water_ahead = true
		
		if is_water_ahead:
			velocity = Vector2.ZERO
		else:
			velocity = direction * speed
			
		if direction.x < 0:
			$Sprite2D.flip_h = true
		elif direction.x > 0:
			$Sprite2D.flip_h = false
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		queue_free()
		if body.has_method("take_damage"):
			body.take_damage(damage)
