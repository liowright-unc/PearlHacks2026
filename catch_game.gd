extends Node2D

var score = 0

## keep score
## start screen: five seconds before timer start
## display timer after 5 seconds pass

signal finished_catchgame(score)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var catch_timer = get_node("Timer")
	catch_timer.timeout.emit(end_screen)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func end_screen() -> void:
	## show score
	## on click
	## send signal to switch
	finished_catchgame.emit(score)
