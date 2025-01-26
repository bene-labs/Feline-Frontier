class_name Asteroid
extends RigidBody2D

static var prefab =  preload("res://scenes/asteroid.tscn")

static var min_speed = 40
static var max_speed = 250

var speed : float

static func spawn(difficulty, position):
	print("spawn!")
	var new_asteroid = prefab.instantiate()
	new_asteroid.speed = randf_range(min_speed * difficulty * 0.67, max_speed * difficulty * 0.67)
	if position.y > 0:
		new_asteroid.rotation_degrees = 270.0 + randf_range(-20, 20) 
	else:
		new_asteroid.rotation_degrees = 90 + randf_range(-20, 20) 
	new_asteroid.global_position = position
	return new_asteroid

func _ready() -> void:
	apply_central_impulse(Vector2(speed, 0).rotated(rotation))


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
