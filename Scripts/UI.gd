class_name UI extends Control

@export_category("Configurations")
@export var extra_lives: Array[ExtraLife]
@export var bonus_time: int

@export_category("Text")
@export var score_txt: String
@export var lives_txt: String
@export var bonus_txt: String

@export_category("Indicators")
@export var lives: int
var bonus: int
var score: int

@export_category("Nodes")
@export var score_label: Label
@export var lives_label: Label
@export var bonus_label: Label
@export var main: Main

@export_category("Scenes")
@export var game_over: PackedScene


func _process(delta: float) -> void:
	score_label.text = score_txt + str(score)
	lives_label.text = lives_txt + str(lives)
	bonus_label.text = bonus_txt + str(bonus)

func _on_timer_timeout() -> void:
	if bonus > 0:
		main.player.invincibility = true
		bonus -= 1
	else:
		main.player.invincibility = false


func _on_add_score(_score: int) -> void:
	score += _score
	for i in extra_lives:
		if score >= i.score and not i.got:
			lives += 1
			i.got = true

func _on_add_score_at_bonus_time(_score: int) -> void:
	if bonus > 0:
		_on_add_score(_score)

func _on_lost_live() -> void:
	if lives > 0:
		lives -= 1
	else:
		_game_over()

func _on_start_bonus() -> void:
	bonus = bonus_time


func _game_over() -> void:
	Singleton.score = score
	get_tree().change_scene_to_file(game_over.resource_path)
