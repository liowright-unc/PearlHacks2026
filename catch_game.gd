extends Node2D

var score = 0
var rng = RandomNumberGenerator.new()
var screen_size
@onready var spawntimer = $SpawnTimer
@onready var startlabel = $StartInst
@onready var Score = $Score
@onready var endgame = $Endgame
@onready var time_label = $TimeLabel
@onready var timer = $Timer
var falling_item = preload("res://falling_item.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	time_label.visible = false
	startlabel.visible = true
	Score.visible = false
	endgame.visible = false
	
	#5 seconds to game start
	await get_tree().create_timer(3).timeout
	spawntimer.start()
	await get_tree().create_timer(2).timeout
	startlabel.visible = false
	spawntimer.start()
	time_label.visible = true
	
	SignalBus.item_caught.connect(score_update)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_timer()
	
func update_timer() -> void:
	time_label.text = str(ceil(timer.time_left))
		
func score_update() -> void:
	score += 10
	
func _on_timer_timeout() -> void:
	# end screen
	Score.visible = true
	endgame.visible = true
	spawntimer.stop()

func _on_spawn_timer_timeout() -> void:
	print("spawn success")
	var new_instance = falling_item.instantiate()
	new_instance.global_position = Vector2(rng.randi_range(0,screen_size.x), 0)
	get_tree().current_scene.add_child(new_instance)
	new_instance.visible = true

func _on_endgame_pressed() -> void:
	SignalBus.finished_catchgame.emit(score)
	SignalBus.current_scene_num += 1
	get_tree().change_scene_to_file("res://main.tscn")
