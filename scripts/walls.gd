extends Node2D

var walls : Array


func _ready() -> void:
	walls = get_children()


func _process(delta: float) -> void:
	for wall in walls:
		wall.global_position = Vector2(Player.traveled_distance, wall.global_position.y)
