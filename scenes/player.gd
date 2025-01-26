class_name Player
extends RigidBody2D

@export var rotation_speed := 10.0
@export var boost_speed = 100.0

var boost_velcotiy := Vector2.ZERO
var rotation_velocity := 0.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	rotation_degrees += rotation_velocity * delta
	apply_central_force(boost_velcotiy)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("boost"):
		print("Boost")
		boost_velcotiy = Vector2(boost_speed, 0).rotated(rotation)
	elif event.is_action_released("boost"):
		print("No boost")
		boost_velcotiy = Vector2(0, 0)
	if event.is_action_pressed("roate_right"):
		rotation_velocity = rotation_speed
	elif event.is_action_released("roate_right"):
		rotation_velocity = 0.0
	if event.is_action_pressed("rotate_left"):
		rotation_velocity = -rotation_speed
	elif event.is_action_released("rotate_left"):
		rotation_velocity = 0.0
