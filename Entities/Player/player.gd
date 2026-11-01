class_name Player
extends CharacterBody2D

# Variablen die wir ändern könnten für Evolution

var GROUNDSPEED : float = 20
var SWIMMINGSPEED : float = 20
@export var tile_map: TileMapLayer 
@export var shadow: Sprite2D
@export var sprite: Sprite2D

func _read() -> void:
	add_to_group("player")

enum Terrain {
	GROUND,
	WATER
}
var hp : float = 100
var damage : float = 10
var GroundSpeed_Coefficient : float = 0.8
var SwimmingSpeed_Coefficient : float = 0.8
var hp_Coefficient : float
var damage_Coefficient : float
var poisonResistance : float
@export var animation_sprites: Sprite2D
@export var animation_player: AnimationPlayer

var isJumping: bool = false
var facing_right: bool = true

var input_vector := Input.get_vector("left", "right", "up", "down")

func _physics_process(_delta: float) -> void:
	hp-=0.1
	print(str(hp))
	input_vector = Input.get_vector("left", "right", "up", "down")
	
	if input_vector != Vector2.ZERO:
		if current_terrain==Terrain.GROUND: 
			GroundSpeed_Coefficient+=0.005
		if current_terrain==Terrain.WATER: 
			SwimmingSpeed_Coefficient+=0.005
	
	if input_vector.x > 0:
		facing_right = true
	elif input_vector.x < 0:
		facing_right = false
	
	if current_terrain==Terrain.GROUND:
		velocity = input_vector * GROUNDSPEED
		sprite.z_index = 40
		shadow.z_index = 25
	elif current_terrain==Terrain.WATER:
		velocity = input_vector * SWIMMINGSPEED
		sprite.z_index = 10
		shadow.z_index = 40
	move_and_slide()
	check_terrain()
	
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

func evolution():
	GROUNDSPEED *= GroundSpeed_Coefficient
	SWIMMINGSPEED *= SwimmingSpeed_Coefficient

func start_jump() -> void:
	isJumping = true
	
	if facing_right:
		animation_player.play("jump_right")
	else:
		animation_player.play("jump_left")
	
	await animation_player.animation_finished
	if input_vector == Vector2.ZERO:
		if facing_right:
			animation_sprites.frame = 0
		else:
			animation_sprites.frame = 1
	
	isJumping = false
