extends CharacterBody2D


const SPEED = 300.0
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# Clamp position between 0 and screen size
	# Use sprite size (e.g., 32x32) for padding
	position.x = clamp(position.x, 0 + 16, screen_size.x - 16)
	position.y = clamp(position.y, 0 + 16, screen_size.y - 16)

	move_and_slide()
