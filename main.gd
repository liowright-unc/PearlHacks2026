extends Node2D

const SCENES = ["opening", "res://CatchGame.tscn", "America_fin"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.current_scene_num = 0
	SignalBus.current_control = SCENES[SignalBus.current_scene_num]
	SignalBus.final_score = 0
	
	var _opening = load("res://timelines/opening.dtl")
	var _catchgame_scene = load("res://CatchGame.tscn")
	var _America_fin = load("res://timelines/America_fin.dtl")
	SignalBus.finished_catchgame.connect(add_to_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	control(SignalBus.current_control)

func control(current) -> void: #which timeline/minigame
	
	if current == "opening" or "America_fin": #if it's a timeline
		if Dialogic.current_timeline != null: #prevent simultaneous
			return
		else: 
			Dialogic.paused = false
			Dialogic.start(current)
			await Dialogic.timeline_ended
			Dialogic.paused = true
			SignalBus.current_scene_num += 1
			
	else: #if it's a minigame
		get_tree().change_scene_to_file(current)
		await SignalBus.finished_catchgame
	
	SignalBus.current_control = SCENES[SignalBus.current_scene_num]
	
func add_to_score(add) -> void:
	SignalBus.final_score += add
	print(SignalBus.final_score)
	
