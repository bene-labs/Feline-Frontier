class_name CatFood
extends RigidBody2D

static var prefab =  preload("res://scenes/cat_food.tscn")
const MAX_LIFETIME = 20.0

@export var energy_gain := 250

var life_time := 0.0
var is_visible := false
const MIN_SIZE := 0.5
const MAX_SIZE := 1.5
var size := 1.0


static func spawn(difficulty, position):
	var new_cat_food = prefab.instantiate()
	new_cat_food.size = randf_range(MIN_SIZE, MAX_SIZE)
	new_cat_food.global_position = position
	new_cat_food.rotation_degrees = randf_range(0, 365)
	return new_cat_food


func _ready() -> void:
	$Sprite2D.scale *= Vector2(size, size)
	$CollisionPolygon2D.scale *= Vector2(size, size)
	$VisibleOnScreenNotifier2D.scale *= Vector2(size, size)


func _process(delta):
	life_time += delta
	if not is_visible and life_time > MAX_LIFETIME:
		queue_free()


func consume() -> float:
	print("EAT!")
	queue_free()
	return energy_gain


func _on_visible_on_screen_notifier_2d_screen_entered():
	life_time = 0
	is_visible = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	is_visible = false
