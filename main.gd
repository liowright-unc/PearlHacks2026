extends Node2D

const SCENES = ["opening", "res://CatchGame.tscn", "America_fin", "France", "res://CatchGame.tscn", "France_fin", "China", "res://CatchGame.tscn", "China_fin"]
@onready var final_score_label = $FinalScore
@onready var friendship_bonus = $FriendshipBonus

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	final_score_label.visible = false
	friendship_bonus.visible = false
	
	var _opening = load("res://timelines/opening.dtl")
	var _catchgame_scene = load("res://CatchGame.tscn")
	var _America_fin = load("res://timelines/America_fin.dtl")
	SignalBus.finished_catchgame.connect(add_to_score)
	Dialogic.signal_event.connect(_on_dialogic_signal)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if SignalBus.current_scene_num == 9:
		get_tree().quit()
	
	SignalBus.current_control = SCENES[SignalBus.current_scene_num]
	control(SignalBus.current_control)

func control(current) -> void: #which timeline/minigame

	
	if current == "opening" or current == "America_fin" or current == "France" or current == "France_fin" or current == "China" or current == "China_fin": #if it's a timeline
		if Dialogic.current_timeline != null: #prevent simultaneous
			return
		else: 
			Dialogic.paused = false
			Dialogic.start(current)
			await Dialogic.timeline_ended
			Dialogic.paused = true
			SignalBus.current_scene_num += 1
			
	else: #if it's a minigame
		SignalBus.current_scene_num += 1
		get_tree().change_scene_to_file(current)
	
func add_to_score(add) -> void:
	SignalBus.final_score += add
	print(SignalBus.final_score)
	
func _on_dialogic_signal(argument) -> void:
	if argument == "finaltime":
		final_score_label.visible = true
	if argument == "friendtime":
		SignalBus.final_score += 100
		friendship_bonus.visible = true
		await get_tree().create_timer(3).timeout
		friendship_bonus.visible = false
		final_score_label.visible = false
	
