extends Node2D

@export var asteroid_spawn_chance = 0.16
@export var min_spawn_time := 0.2
@export var max_spawn_time := 1.0


var spawn_areas : Array[Area2D]
var diffculty = 1.0


func _ready() -> void:
	for child in get_children():
		if not child is Area2D:
			continue
		spawn_areas.append(child)
	_on_game_start()


func _process(delta: float) -> void:
	diffculty = 1.0 + Player.traveled_distance / 100000
	for area in spawn_areas:
		area.global_position.x = Player.traveled_distance


func spawn_asteroid():
	var chosen_area = spawn_areas[randi() % spawn_areas.size()]
	var col_shape = chosen_area.get_child(0)
	var centerpos = col_shape.global_position
	var size = col_shape.shape.extents
	var position_in_area : Vector2
	position_in_area.x = (randi() % int(size.x)) - (size.x/2) + centerpos.x
	position_in_area.y = (randi() % int(size.y)) - (size.y/2) + centerpos.y
	add_child(Asteroid.spawn(diffculty, position_in_area))


func _on_spawn_timer_timeout() -> void:
	%SpawnTimer.stop()
	%SpawnTimer.start(randf_range(min_spawn_time / diffculty, max_spawn_time / diffculty))
	if randf() <= asteroid_spawn_chance:
		spawn_asteroid()


func _on_game_start() -> void:
	%SpawnTimer.start(randf_range(min_spawn_time / diffculty, max_spawn_time / diffculty))
