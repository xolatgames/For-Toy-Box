class_name Enemy extends Movable

enum Direction { Right, Up, Left, Down }

var next_direction_delay: int = 0
var _direction: Direction

@export_category("Characteristics")
@export var score: int

signal add_score
signal lost_live
signal respawn


func _physics_process(delta: float) -> void:
	var grid = global_position.snapped(grid_scale)
	if (global_position.distance_to(grid) < 1.0):
		global_position = grid
		
		var direction: Vector2
		if next_direction_delay <= 0:
			_direction = randi() % Direction.size()
			next_direction_delay = randi() % 4
		else:
			next_direction_delay -= 1
		
		match _direction:
			Direction.Right:
				if not free_space_checker_right.has_overlapping_bodies():
					direction = Vector2.RIGHT * speed
			Direction.Up:
				if not free_space_checker_up.has_overlapping_bodies():
					direction = Vector2.UP * speed
			Direction.Left:
				if not free_space_checker_left.has_overlapping_bodies():
					direction = Vector2.LEFT * speed
			Direction.Down:
				if not free_space_checker_down.has_overlapping_bodies():
					direction = Vector2.DOWN * speed
		
		velocity = direction
	
	move_and_slide()


func _on_contact_area_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.invincibility:
			add_score.emit(score)
			queue_free()
		else:
			lost_live.emit()
			queue_free()
		respawn.emit()
