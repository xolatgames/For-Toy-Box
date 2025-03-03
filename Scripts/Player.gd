class_name Player extends Movable


func _physics_process(delta: float) -> void:
	var grid = global_position.snapped(grid_scale)
	if (global_position.distance_to(grid) < 2.0):
		global_position = grid
		
		var direction: Vector2
		
		if Input.is_action_pressed("Right"):
			if not free_space_checker_right.has_overlapping_bodies():
				direction = Vector2.RIGHT * speed
		if Input.is_action_pressed("Up"):
			if not free_space_checker_up.has_overlapping_bodies():
				direction = Vector2.UP * speed
		if Input.is_action_pressed("Left"):
			if not free_space_checker_left.has_overlapping_bodies():
				direction = Vector2.LEFT * speed
		if Input.is_action_pressed("Down"):
			if not free_space_checker_down.has_overlapping_bodies():
				direction = Vector2.DOWN * speed
		
		velocity = direction
	
	move_and_slide()
