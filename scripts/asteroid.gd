class_name Asteroid
extends RigidBody2D

static var prefab =  preload("res://scenes/asteroid.tscn")

static var min_speed = 15
static var max_speed = 150

const MAX_LIFETIME = 20.0

@export var energy_drain := 100

var speed : float
var life_time := 0.0
var is_visible := false
const MIN_SIZE := 0.4
const MAX_SIZE := 1.5
var size := 1.0


static func spawn(difficulty, position, launch = true):
	var new_asteroid = prefab.instantiate()
	new_asteroid.size = randf_range(MIN_SIZE, MAX_SIZE) / (2 if launch else 1) + difficulty / 32 
	if launch:
		new_asteroid.speed = randf_range(min_speed * (1 + difficulty / 10), max_speed * (1 + difficulty / 10))
		if position.y > 0: 
			new_asteroid.rotation_degrees = 270.0 + randf_range(-30, 30) 
		else:
			new_asteroid.rotation_degrees = 90 + randf_range(-30, 30) 
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
	is_visible = false
	#queue_free()


func get_energy_drain():
	return energy_drain


func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_visible and body is Asteroid:
		$HitStreamPlayer.pitch_scale = randf_range(0.6, 1.4)
		$HitStreamPlayer.play()
