extends Area2D

var fall_speed
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#visible = false
	screen_size = get_viewport_rect().size
	
	if SignalBus.current_scene_num == 2: #America
		fall_speed = 350
	if SignalBus.current_scene_num == 5: # France
		fall_speed = 450
	if SignalBus.current_scene_num == 8: # China
		fall_speed = 550

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += fall_speed * delta
	
	var bodies = get_overlapping_bodies()
	if $"../../Catcher" in bodies:
		SignalBus.item_caught.emit()
		queue_free()
	
	if position.y > 600:
		queue_free()
