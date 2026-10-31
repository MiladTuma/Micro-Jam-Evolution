extends CharacterBody2D

@export var speed: float = 150.0
var player: Node2D = null

func _ready() -> void:
	# Find the player using a Group (make sure your player is added to the "player" group)
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if player:
		# Calculate direction toward the player
		var direction: Vector2 = global_position.direction_to(player.global_position)
		
		# Set velocity and move
		velocity = direction * speed
		move_and_slide()
