class_name Asteroid
extends RigidBody2D

static var prefab =  preload("res://scenes/asteroid.tscn")

static var min_speed = 25
static var max_speed = 200

const MAX_LIFETIME = 10.0

@export var energy_drain := 100

var speed : float
var life_time := 0.0
var is_visible := false
const MIN_SIZE := 0.4
const MAX_SIZE := 1.5
var size := 1.0


static func spawn(difficulty, position, launch = true):
	var new_asteroid = prefab.instantiate()
	new_asteroid.size = randf_range(MIN_SIZE, MAX_SIZE) + difficulty / 4
	if launch:
		new_asteroid.speed = randf_range(min_speed * difficulty * 0.67, max_speed * difficulty * 0.67)
		if position.y > 0: 
			new_asteroid.rotation_degrees = 270.0 + randf_range(-20, 20) 
		else:
			new_asteroid.rotation_degrees = 90 + randf_range(-20, 20) 
	new_asteroid.global_position = position
	return new_asteroid


func _ready() -> void:
	$Polygon2D.scale *= Vector2(size, size)
	$CollisionPolygon2D.scale *= Vector2(size, size)
	$VisibleOnScreenNotifier2D.scale *= Vector2(size, size)
	apply_central_impulse(Vector2(speed, 0).rotated(rotation))


func _process(delta):
	life_time += delta
	if not is_visible and life_time > MAX_LIFETIME:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_visible = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func get_energy_drain():
	return energy_drain
