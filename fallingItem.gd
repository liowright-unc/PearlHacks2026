extends Area2D

const FALL_SPEED = 200
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#visible = false
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += FALL_SPEED * delta
	
	var bodies = get_overlapping_bodies()
	if $"../../Catcher" in bodies:
		SignalBus.item_caught.emit()
		queue_free()
	
	if position.y > 600:
		queue_free()
