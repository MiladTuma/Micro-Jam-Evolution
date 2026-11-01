class_name Player
extends CharacterBody2D

# Variablen die wir ändern könnten für Evolution

var GROUNDSPEED : float = 20
var SWIMMINGSPEED : float = 20
@export var tile_map: TileMapLayer 
@export var shadow: Sprite2D
@export var sprite: Sprite2D

func _ready() -> void:
	add_to_group("player")

enum Terrain {
	GROUND,
	WATER
}

@export var animation_sprites: Sprite2D
@export var animation_player: AnimationPlayer

var isJumping: bool = false
var facing_right: bool = true

var input_vector := Input.get_vector("left", "right", "up", "down")
var flies_in_mouth: Array[Node2D] = []


func _physics_process(_delta: float) -> void:
	input_vector = Input.get_vector("left", "right", "up", "down")
	
	if input_vector.x > 0:
		facing_right = true
	elif input_vector.x < 0:
		facing_right = false
	
	if current_terrain == Terrain.GROUND:
		velocity = input_vector * GROUNDSPEED
		sprite.z_index = 40
		shadow.z_index = 25
	elif current_terrain == Terrain.WATER:
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

func _process(delta: float) -> void:
	current_health -= (5 * poison_resistance) * delta
	
	if current_health == 0 and not is_evolutioning:
		evolution()
	
	learn_evolution(delta)
	



var is_evolutioning : bool = false

var max_health : float = 30
var current_health: float = max_health:
	set(value):
		current_health = max(0, value)

# Fass den Code nicht an außer du heißt Milad oder Eugeniu

const original_ground_speed: float = 0.3
var ground_speed_coefficient : float = original_ground_speed

const original_swimming_speed:  float = 0.3
var swimming_speed_coefficient : float = original_swimming_speed

const original_hp_coefficient : float = 1
var hp_coefficient : float = 0.8

var damage_Coefficient : float

# Je niedriger die Resistance, desto niedriger der Schaden.
const original_poison_resistance : float = 0.995
var poison_resistance_coefficient : float = original_poison_resistance
var poison_resistance: float = 1:
	set(value):
		poison_resistance = max(0, value)


func evolution():
	is_evolutioning = true
	GROUNDSPEED *= ground_speed_coefficient
	SWIMMINGSPEED *= swimming_speed_coefficient
	poison_resistance *= poison_resistance_coefficient

	
	hp_coefficient = original_hp_coefficient
	ground_speed_coefficient = original_ground_speed
	swimming_speed_coefficient = original_swimming_speed
	poison_resistance_coefficient = original_poison_resistance
	
	current_health = max_health
	
	is_evolutioning = false
	
	# Teste Ob die Vars nicht zu hoch oder zu tief sind.
	GROUNDSPEED = clampf(GROUNDSPEED, 5, 200)
	SWIMMINGSPEED = clampf(SWIMMINGSPEED, 5, 200)
	max_health = clampf(SWIMMINGSPEED, 12.5, 100)

func learn_evolution(delta):
	if input_vector != Vector2.ZERO:
		if current_terrain==Terrain.GROUND:
			ground_speed_coefficient += 0.2 * delta
		if current_terrain==Terrain.WATER: 
			swimming_speed_coefficient += 0.2 * delta
	poison_resistance_coefficient -= 0.01 * delta
	
	if Input.is_action_just_pressed("eat"):
		
			if flies_in_mouth.size() > 0:
		
				var fly = flies_in_mouth[0]
				fly.get_eaten()
				flies_in_mouth.remove_at(0) 
		
		
				hp_coefficient += 0.2
				current_health +=5
				print("nom nom ")

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



func _on_mouth_area_body_entered(body: Node2D) -> void:
	if body.has_method("get_eaten"):
		if not flies_in_mouth.has(body):
			flies_in_mouth.append(body)


func _on_mouth_area_body_exited(body: Node2D) -> void:
	if flies_in_mouth.has(body):
		flies_in_mouth.erase(body)
