class_name Movable extends CharacterBody2D

var field_size: Vector2i
var grid_scale: Vector2

@export_category("Characteristics")
@export var speed: float = 200.0

@export_category("Nodes")
@export var free_space_checker_right: Area2D
@export var free_space_checker_up: Area2D
@export var free_space_checker_left: Area2D
@export var free_space_checker_down: Area2D


func _process(delta: float) -> void:
	if global_position.x > field_size.x * grid_scale.x + grid_scale.x/2:
		global_position.x = -grid_scale.x/2
	if global_position.x < -grid_scale.x/2:
		global_position.x = field_size.x * grid_scale.x + grid_scale.x/2
	if global_position.y > field_size.y * grid_scale.y + grid_scale.y/2:
		global_position.y = -grid_scale.y/2
	if global_position.y < -grid_scale.y/2:
		global_position.y = field_size.y * grid_scale.y + grid_scale.y/2
