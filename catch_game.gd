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
var apple = preload("res://assets/ingredients/apple.png")
var egg = preload("res://assets/ingredients/egg-cartoon-style.png")
var sugar = preload ("res://assets/ingredients/sugar.png")
var jam = preload("res://assets/ingredients/jam3.png")
var butter = preload("res://assets/ingredients/butter.png")
var America = [apple, egg, sugar]
var France = [jam, egg, sugar]
var China = [butter, egg, sugar]

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
	SignalBus.final_score += 10
	
func _on_timer_timeout() -> void:
	# end screen
	Score.visible = true
	endgame.visible = true
	spawntimer.stop()

func _on_spawn_timer_timeout() -> void:
	print("spawn success")
	var new_instance = falling_item.instantiate()
	new_instance.global_position = Vector2(rng.randi_range(0,screen_size.x), 0)
	if SignalBus.current_scene_num == 2:
		new_instance.get_child(0).get_child(0).texture = America.pick_random()
	if SignalBus.current_scene_num == 5:
		new_instance.get_child(0).get_child(0).texture = France.pick_random()
	if SignalBus.current_scene_num == 8:
		new_instance.get_child(0).get_child(0).texture = China.pick_random()
	get_tree().current_scene.add_child(new_instance)
	new_instance.visible = true

func _on_endgame_pressed() -> void:
	SignalBus.finished_catchgame.emit(score)
	get_tree().change_scene_to_file("res://main.tscn")
