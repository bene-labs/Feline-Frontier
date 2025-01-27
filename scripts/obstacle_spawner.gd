extends Node2D

const INIT_MIN_OBSTACLE := 2
const INIT_MAX_OBSTACLE := 5

var min_obstacles := INIT_MIN_OBSTACLE
var max_obstacles := INIT_MAX_OBSTACLE
var diffculty = 1.0


func _process(delta: float) -> void:
	diffculty = 1.0 + Player.traveled_distance / 100000
	min_obstacles = int(INIT_MIN_OBSTACLE + diffculty / 2)
	max_obstacles = int(INIT_MAX_OBSTACLE + diffculty)
 

func spawn_asteroid():
	var col_shape = %SpawnArea.get_child(0)
	var centerpos = col_shape.global_position
	var size = col_shape.shape.extents
	var position_in_area : Vector2
	position_in_area.x = (randi() % int(size.x)) - (size.x/2) + centerpos.x
	position_in_area.y = (randi() % int(size.y)) - (size.y/2) + centerpos.y
	await get_tree().process_frame
	add_child(Asteroid.spawn(diffculty, position_in_area))


func _on_new_area_trigger_body_entered(body):
	for i in range(randi_range(min_obstacles, max_obstacles)):
		spawn_asteroid()
	global_position = Vector2(global_position.x + %DimensionRef.size.x, global_position.y)
