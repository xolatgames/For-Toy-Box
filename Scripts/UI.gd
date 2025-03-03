class_name UI extends Control

@export_category("Configurations")
@export var extra_lives: Array[ExtraLife]

@export_category("Text")
@export var score_txt: String
@export var lives_txt: String
@export var time_txt: String

@export_category("Indicators")
@export var lives: int
@export var time: int
var score: int

@export_category("Nodes")
@export var score_label: Label
@export var lives_label: Label
@export var time_label: Label
@export var main: Main

@export_category("Scenes")
@export var game_over: PackedScene


func _process(delta: float) -> void:
	score_label.text = score_txt + str(score)
	lives_label.text = lives_txt + str(lives)
	time_label.text = time_txt + str(time)

func _on_timer_timeout() -> void:
	if time > 0:
		time -= 1
	else:
		_game_over()


func _on_add_score(_score: int) -> void:
	score += _score
	for i in extra_lives:
		if score >= i.score and not i.got:
			lives += 1
			i.got = true

func _on_lost_live() -> void:
	if lives > 0:
		lives -= 1
	else:
		_game_over()

func _on_add_time(_time: int) -> void:
	time += _time

func _game_over() -> void:
	Singleton.score = score
	get_tree().change_scene_to_file(game_over.resource_path)
