class_name GameOver extends Control

@export_category("Scenes")
@export var main: String

@export_category("Nodes")
@export var score_label: Label

@export_category("Text")
@export var score_txt: String


func _ready() -> void:
	score_label.text = score_txt + str(Singleton.score)

func _on_try_again_pressed() -> void:
	get_tree().change_scene_to_file(main)
