extends Node2D

@export var player : Player
var walls : Array


func _ready() -> void:
	walls = get_children()


func _process(delta: float) -> void:
	for wall in walls:
		wall.global_position = Vector2(player.position.x, wall.global_position.y)
