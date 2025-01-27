class_name Player
extends RigidBody2D

signal power_changed(new_value: float)
signal hit

@export var rotation_speed := 10.0
@export var boost_speed = 100.0
@export var max_power := 1000.0
@export var boost_cost_per_second := 50

@onready var remaining_power := max_power
var boost_velcotiy := Vector2.ZERO
var rotation_velocity := 0.0
static var traveled_distance := 0.0
var start_postion : Vector2


func _ready() -> void:
	start_postion = global_position


func lose_power(amount: float):
	remaining_power = clamp(remaining_power - amount, 0, max_power)
	if remaining_power == 0:
		$AnimatedSprite.play("default")
		boost_velcotiy = Vector2(0, 0)
	power_changed.emit(remaining_power / max_power)


func _process(delta: float) -> void:
	if boost_velcotiy != Vector2.ZERO:
		lose_power(boost_cost_per_second * delta)


func _physics_process(delta: float) -> void:
	rotation_degrees += rotation_velocity * delta
	apply_central_force(boost_velcotiy)
	traveled_distance = clamp(global_position.x - start_postion.x, 0, INF)


func _input(event: InputEvent) -> void:
	if remaining_power >= 0 and event.is_action_pressed("boost"):
		$AnimatedSprite.play("boost")
		boost_velcotiy = Vector2(boost_speed, 0).rotated(rotation)
	elif event.is_action_released("boost"):
		$AnimatedSprite.play("default")
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


func _on_obstacle_detector_body_entered(body):
	if body.has_method("get_energy_drain"):
		lose_power(body.get_energy_drain())
		hit.emit()
