extends Node2D

@export var fly_scene: PackedScene
@export var tile_map: TileMapLayer 
@export var max_flies: int = 15
@onready var timer: Timer = $Timer

var spawn_area: Rect2 

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	
	if tile_map:
		calculate_spawn_area()
	else:
		print("Eror")


func calculate_spawn_area() -> void:
	
	var used_rect = tile_map.get_used_rect()
	
	
	var start_pos = tile_map.map_to_local(used_rect.position)
	var end_pos = tile_map.map_to_local(used_rect.end)
	
	
	spawn_area = Rect2(start_pos, end_pos - start_pos)
	
	print("Границы карты для спавна: ", spawn_area)

func _on_timer_timeout() -> void:
	if get_tree().get_nodes_in_group("flies").size() >= max_flies:
		return

	var random_x = randf_range(spawn_area.position.x, spawn_area.end.x)
	var random_y = randf_range(spawn_area.position.y, spawn_area.end.y)
	var spawn_position = Vector2(random_x, random_y)

	if is_position_free(spawn_position):
		var new_fly = fly_scene.instantiate()
		new_fly.global_position = spawn_position
		add_child(new_fly) 
		new_fly.add_to_group("flies")

func is_position_free(pos: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collision_mask = 1 
	
	var result = space_state.intersect_point(query)
	return result.is_empty()
