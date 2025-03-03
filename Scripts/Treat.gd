class_name Treat extends Area2D

@export_category("Nodes")
@export var sprite: Sprite2D

var treat: TreatClass

signal collected


func _ready() -> void:
	sprite.texture = treat.sprite


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		collected.emit(treat.type, treat.score)
		queue_free()
