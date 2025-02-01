extends Node2D

@export var asteroid_spawn_chance = 0.25
@export var min_spawn_time := 0.25
@export var max_spawn_time := 1


var spawn_areas : Array[Area2D]
var diffculty = 1.0
var has_started := false


func _ready() -> void:
	for child in get_children():
		if not child is Area2D:
			continue
		spawn_areas.append(child)


func _process(delta: float) -> void:
	diffculty = 1.0 + Player.traveled_distance / 10_000
	for area in spawn_areas:
		area.global_position.x = Player.traveled_distance


func spawn_asteroid():
	var chosen_area = spawn_areas[randi() % spawn_areas.size()]
	var col_shape = chosen_area.get_child(0)
	var centerpos = col_shape.global_position
	var size = col_shape.shape.extents
	var min = centerpos - size
	var max = centerpos + size
	var position_in_area : Vector2
	position_in_area.x = randf_range(min.x, max.x)
	position_in_area.y = randf_range(min.y, max.y)
	$"../Obstacles".add_child(Asteroid.spawn(diffculty, position_in_area))


func _on_spawn_timer_timeout() -> void:
	%SpawnTimer.stop()
	%SpawnTimer.start(randf_range(min_spawn_time / (1 + diffculty / 3), max_spawn_time / (1 + diffculty / 3)))
	if randf() <= asteroid_spawn_chance:
		spawn_asteroid()


func _on_intense_mode_start() -> void:
	%SpawnTimer.start(randf_range(min_spawn_time / (1 + diffculty / 3), max_spawn_time / (1 + diffculty / 3)))
