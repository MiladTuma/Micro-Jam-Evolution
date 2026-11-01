extends Node2D

@export var snake_scene: PackedScene
@export var tile_map: TileMapLayer
@export var max_snakes: int = 5
@onready var timer: Timer = $Timer

var spawn_area: Rect2

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	calculate_spawn_area()

func calculate_spawn_area() -> void:
	var used_rect = tile_map.get_used_rect()
	var start_pos = tile_map.map_to_local(used_rect.position)
	var end_pos = tile_map.map_to_local(used_rect.end)
	spawn_area = Rect2(start_pos, end_pos - start_pos)

func _on_timer_timeout() -> void:
	if get_tree().get_nodes_in_group("snakes").size() >= max_snakes:
		return

	var spawn_position = get_valid_spawn_position()
	
	if spawn_position != Vector2.INF:
		var new_snake = snake_scene.instantiate()
		new_snake.global_position = spawn_position
		new_snake.tile_map = tile_map
		add_child(new_snake)
		new_snake.add_to_group("snakes")

func get_valid_spawn_position() -> Vector2:
	var max_attempts = 20
	
	for i in range(max_attempts):
		var random_x = randf_range(spawn_area.position.x, spawn_area.end.x)
		var random_y = randf_range(spawn_area.position.y, spawn_area.end.y)
		var test_pos = Vector2(random_x, random_y)

		var cell = tile_map.local_to_map(tile_map.to_local(test_pos))
		var tile_data = tile_map.get_cell_tile_data(cell)

		if tile_data != null:
			if tile_data.get_custom_data("terrain") == 0:
				var space_state = get_world_2d().direct_space_state
				var query = PhysicsPointQueryParameters2D.new()
				query.position = test_pos
				query.collision_mask = 1
				
				var result = space_state.intersect_point(query)
				
				if result.is_empty():
					return test_pos

	return Vector2.INF
