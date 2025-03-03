class_name Balloon extends Area2D

@export_category("Nodes")
@export var sprite: Sprite2D

var ballon: BalloonClass

signal collected


func _ready() -> void:
	sprite.texture = ballon.sprite


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		collected.emit(ballon.type)
		queue_free()
