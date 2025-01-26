class_name Player
extends RigidBody2D

@export var rotation_speed := 10.0
@export var boost_speed = 100.0

var boost_velcotiy := Vector2.ZERO
var rotation_velocity := 0.0
static var traveled_distance := 0.0
var start_postion : Vector2

func _ready() -> void:
	start_postion = global_position


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	rotation_degrees += rotation_velocity * delta
	apply_central_force(boost_velcotiy)
	traveled_distance = clamp(global_position.x - start_postion.x, 0, INF)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("boost"):
		boost_velcotiy = Vector2(boost_speed, 0).rotated(rotation)
	elif event.is_action_released("boost"):
		boost_velcotiy = Vector2(0, 0)
	elif event.is_action_pressed("break"):
		boost_velcotiy = Vector2(-boost_speed, 0).rotated(rotation)
	elif event.is_action_released("break"):
		boost_velcotiy = Vector2(0, 0)
	
	if event.is_action_pressed("roate_right"):
		rotation_velocity = rotation_speed
	elif event.is_action_released("roate_right"):
		rotation_velocity = 0.0
	if event.is_action_pressed("rotate_left"):
		rotation_velocity = -rotation_speed
	elif event.is_action_released("rotate_left"):
		rotation_velocity = 0.0
