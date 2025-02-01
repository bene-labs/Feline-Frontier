extends Node2D

signal intense_mode_started

const INIT_MIN_OBSTACLE := 1
const INIT_MAX_OBSTACLE := 5

var min_obstacles := INIT_MIN_OBSTACLE
var max_obstacles := INIT_MAX_OBSTACLE
var diffculty = 1.0
var started_intense_mode := false


func _process(delta: float) -> void:
	diffculty = 1.0 + Player.traveled_distance / 10_000
	if not started_intense_mode and diffculty >= 3:
		AudioController.play_intense()
		intense_mode_started.emit()
		started_intense_mode = true
	min_obstacles = int(INIT_MIN_OBSTACLE + diffculty / 4)
	max_obstacles = int(INIT_MAX_OBSTACLE + diffculty / 2)
 

func spawn_asteroid():
	var col_shape = %SpawnArea.get_child(0)
	var centerpos = col_shape.global_position
	var size = col_shape.shape.extents
	var min = centerpos - size
	var max = centerpos + size
	var position_in_area : Vector2
	position_in_area.x = randf_range(min.x, max.x)
	position_in_area.y = randf_range(min.y, max.y)
	await get_tree().process_frame
	$"../Obstacles".add_child(Asteroid.spawn(diffculty, position_in_area, false))

func spawn_cat_food():
	var col_shape = %SpawnArea.get_child(0)
	var centerpos = col_shape.global_position
	var size = col_shape.shape.extents
	var min = centerpos - size
	var max = centerpos + size
	var position_in_area : Vector2
	position_in_area.x = randf_range(min.x, max.x)
	position_in_area.y = randf_range(min.y, max.y)
	await get_tree().process_frame
	$"../Obstacles".add_child(CatFood.spawn(diffculty, position_in_area))


func _on_new_area_trigger_body_entered(body):
	print(body.name)
	for i in range(randi_range(min_obstacles, max_obstacles)):
		spawn_asteroid()
	for i in range(int(randf_range(1, 2 + diffculty / 2))):
		spawn_cat_food()
	global_position = Vector2(global_position.x + %DimensionRef.size.x, global_position.y)
