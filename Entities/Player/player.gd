extends CharacterBody2D

# Variablen die wir ändern könnten für Evolution

var SPEED : int = 100
var SWIMMINGSPEED : int = 50
@export var tile_map: TileMapLayer 

enum Terrain {
	GROUND, 
	WATER
}
var hp : int = 100
var damage : int = 10
var Speed_Coefficient : int
var Swimming_Coefficient : int
var hp_Coefficient : int 
var damage_Coefficient : int 
@export var animation_sprites: Sprite2D
@export var animation_player: AnimationPlayer

var isJumping: bool = false
var facing_right: bool = true

# Variablen für Evolution
var SPEED: int = 100
var SWIMMINGSPEED: int = 50


func _physics_process(_delta: float) -> void:
	var input_vector := Input.get_vector("left", "right", "up", "down")

	if input_vector.x > 0:
		facing_right = true
	elif input_vector.x < 0:
		facing_right = false

	velocity = input_vector * SPEED
	move_and_slide()
	check_terrain()

	if current_terrain == Terrain.WATER:
		print("On the watter")

	elif current_terrain == Terrain.GROUND:
		print("on the ground")

var current_terrain: Terrain = Terrain.GROUND

func check_terrain():
	var cell = tile_map.local_to_map(
		tile_map.to_local(global_position)
	)

	var tile_data = tile_map.get_cell_tile_data(cell)

	if tile_data == null:
		return

	var terrain = tile_data.get_custom_data("terrain")

	match terrain:
		0:
			current_terrain = Terrain.GROUND
		1:
			current_terrain = Terrain.WATER

func evolution( ):
	SPEED += 5 * Speed_Coefficient
	SWIMMINGSPEED += 5 * Swimming_Coefficient
	hp += 5 * hp_Coefficient
	damage += 5 * damage_Coefficient

	if isJumping:
		if facing_right and animation_player.current_animation == "jump_left":
			var time = animation_player.current_animation_position
			animation_player.play("jump_right")
			animation_player.seek(time, true)
		
		elif not facing_right and animation_player.current_animation == "jump_right":
			var time = animation_player.current_animation_position
			animation_player.play("jump_left")
			animation_player.seek(time, true)

	if input_vector != Vector2.ZERO and not isJumping:
		start_jump()


func start_jump() -> void:
	isJumping = true

	if facing_right:
		animation_player.play("jump_right")
	else:
		animation_player.play("jump_left")

	await animation_player.animation_finished

	if facing_right:
		animation_sprites.frame = 0
	else:
		animation_sprites.frame = 1

	isJumping = false
