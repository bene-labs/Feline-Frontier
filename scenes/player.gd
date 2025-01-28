class_name Player
extends RigidBody2D

signal power_changed(new_value: float)
signal hit
signal died

@export var rotation_speed := 10.0
@export var boost_speed = 100.0
@export var max_power := 1000.0
@export var boost_cost_per_second := 50
@export var brake_cost_per_second := 20

@onready var remaining_power := max_power
var boost_velcotiy := Vector2.ZERO
var rotation_velocity := 0.0
static var traveled_distance := 0.0
var start_postion : Vector2
var is_invunerable := false

func _ready() -> void:
	start_postion = global_position


func lose_power(amount: float):
	remaining_power = clamp(remaining_power - amount, 0, max_power)
	if remaining_power == 0:
		#$AnimatedSprite.play("default")
		$FireSprite.hide()
		boost_velcotiy = Vector2(0, 0)
	power_changed.emit(remaining_power / max_power)


func gain_power(amount: float):
	remaining_power = clamp(remaining_power + amount, 0, max_power)
	power_changed.emit(remaining_power / max_power)


func _process(delta: float) -> void:
	if boost_velcotiy != Vector2.ZERO:
		lose_power(boost_cost_per_second * delta)


func _physics_process(delta: float) -> void:
	rotation_degrees += rotation_velocity * delta
	apply_central_force(boost_velcotiy)
	traveled_distance = clamp(global_position.x - start_postion.x, 0, INF)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("boost"):
		if remaining_power <= 0:
			power_changed.emit(-1)
		else:
			#$AnimatedSprite.play("boost")
			$FireSprite.show()
			$FireSprite.play("boost")
			boost_velcotiy = Vector2(boost_speed, 0).rotated(rotation)
	elif event.is_action_released("boost"):
		#$AnimatedSprite.play("default")
		$FireSprite.hide()
		boost_velcotiy = Vector2(0, 0)
	elif event.is_action_pressed("break"):
		if remaining_power <= 0:
			power_changed.emit(-1)
		else:
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


func die():
	died.emit()
	queue_free()


func _on_obstacle_detector_body_entered(body):
	if not is_invunerable and body.has_method("get_energy_drain"):
		if remaining_power <= 0:
			die()
			return
		lose_power(body.get_energy_drain())
		hit.emit()
		is_invunerable = true
		$InvulnerabilityTimer.start()
	elif body.has_method("consume"):
		gain_power(body.consume())
	


func _on_invulnerability_timer_timeout():
	is_invunerable = false
