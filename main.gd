extends Node2D

const SCENES = ["opening", "catchgame"]
var current_scene_num = 0
var current_control = SCENES[current_scene_num]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# var gameplay_scene = preload("res://CatchGame.tscn")
	
	finished_catchgame.connect()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	control(current_control)
	current_scene_num += 1


func control(current, event: InputEvent) -> void: #which timeline/minigame
	get_tree().change_scene_to_file(current)
	if current == "opening":
		await Dialogic.timeline_ended
	else:
		await finished_catchgame
	
	
	if Dialogic.current_timeline != null:
		return
	if event is InputEventKey and event.keycode == KEY_ENTER and event.pressed:
		Dialogic.start(current_control)
		get_viewport().set_input_as_handled()
		await Dialogic.timeline_ended
	
	
	Dialogic.start("opening")
	
