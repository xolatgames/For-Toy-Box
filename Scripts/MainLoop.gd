class_name Main extends Node2D

@export_category("Configuration")
@export var field_size: Vector2i = Vector2i(18, 18)
@export var grid_scale: Vector2 = Vector2(32, 32)
@export var enemies_amount: int

@export_category("Spawning Objects")
@export var treats: Array[TreatClass]
@export var ballons: Array[BalloonClass]

@export_category("Packed Scenes")
@export var treat: PackedScene
@export var ballon: PackedScene
@export var enemy: PackedScene

@export_category("Nodes")
@export var player: Player
@export var tile_map: TileMapLayer

var treats_objects: Array[Treat]
var balloons_objects: Array[Balloon]
var enemies_objects: Array[Enemy]

var treat_order: TreatClass.Type
var balloon_order: BalloonClass.Type

signal add_score
signal add_score_at_bonus_time
signal lost_live
signal start_bonus


func _ready() -> void:
	player.field_size = field_size
	player.grid_scale = grid_scale
	
	randomize()
	_respawn_treats()
	_respawn_balloons()
	_respawn_enemies()
	_clear_busy_tiles()


#region Spawning Objects
func _respawn_treats() -> void:
	for i in treats_objects:
		if i != null:
			i.queue_free()
	treats_objects.clear()
	
	for i in treats:
		var pos: Vector2
		while true:
			pos = _random_pos_on_map()
			if tile_map.get_cell_source_id(pos) == -1 and pos != player.position:
				tile_map.set_cell(pos, 2, Vector2i.ZERO)
				break
		var _treat = _spawn_treat(i, pos * grid_scale)
		_treat.collected.connect(_treat_collect)
		treats_objects.append(_treat)

func _respawn_balloons() -> void:
	for i in balloons_objects:
		if i != null:
			i.queue_free()
	balloons_objects.clear()
	
	for i in ballons:
		var pos: Vector2
		while true:
			pos = _random_pos_on_map()
			if tile_map.get_cell_source_id(pos) == -1 and pos.distance_to(player.position) > 128:
				tile_map.set_cell(pos, 2, Vector2i.ZERO)
				break
		var _balloon = _spawn_balloon(i, pos * grid_scale)
		_balloon.collected.connect(_balloon_collect)
		balloons_objects.append(_balloon)

func _respawn_enemies() -> void:
	for i in enemies_objects:
		if i != null:
			i.queue_free()
	enemies_objects.clear()
	
	for i in range(enemies_amount):
		_respawn_enemy()

func _random_pos_on_map() -> Vector2i:
	var pos: Vector2i = Vector2i(randi_range(0, field_size.x), randi_range(0, field_size.y))
	return pos

func _spawn_treat(_treat: TreatClass, pos: Vector2) -> Treat:
	var obj: Treat = treat.instantiate()
	obj.position = pos
	obj.treat = _treat
	add_child(obj)
	return obj

func _spawn_balloon(_ballon: BalloonClass, pos: Vector2) -> Balloon:
	var obj: Balloon = ballon.instantiate()
	obj.position = pos
	obj.ballon = _ballon
	add_child(obj)
	return obj

func _spawn_enemy(pos: Vector2) -> Enemy:
	var obj: Enemy = enemy.instantiate()
	obj.position = pos
	obj.field_size = field_size
	obj.grid_scale = grid_scale
	add_child(obj)
	return obj

func _clear_busy_tiles() -> void:
	for i in tile_map.get_used_cells():
		if tile_map.get_cell_source_id(i) == 2:
			tile_map.set_cell(i)
#endregion Spawning Objects


func _treat_collect(order: TreatClass.Type, score: int) -> void:
	if order == treat_order:
		add_score.emit(score)
		treat_order += 1
		if treat_order >= TreatClass.Type.size():
			treat_order = 0
			_respawn_treats()
			_clear_busy_tiles()
	else:
		treat_order = 0
		_respawn_treats()
		_clear_busy_tiles()

func _balloon_collect(order: BalloonClass.Type) -> void:
	add_score_at_bonus_time.emit(300)
	if order == balloon_order:
		balloon_order += 1
		if balloon_order >= BalloonClass.Type.size():
			start_bonus.emit()
			balloon_order = 0
			_respawn_balloons()
			_clear_busy_tiles()
	else:
		balloon_order = 0
		_respawn_balloons()
		_clear_busy_tiles()

func _add_score(score: int) -> void:
	add_score.emit(score)

func _lost_live() -> void:
	lost_live.emit()

func _respawn_enemy() -> void:
	var pos: Vector2
	while true:
		pos = _random_pos_on_map()
		if tile_map.get_cell_source_id(pos) == -1 and pos.distance_to(player.position) > 128:
			break
	var _enemy = _spawn_enemy(pos * grid_scale)
	_enemy.add_score.connect(_add_score)
	_enemy.lost_live.connect(_lost_live)
	_enemy.respawn.connect(_respawn_enemy)
	enemies_objects.append(_enemy)
