extends Camera2D

var shake_strength = 0
var limit_rect = null
@export var enable_screen_shake = true

@onready var start_offset = offset

func _ready():
	for child in get_children():
		if child is ReferenceRect:
			limit_rect = child.get_global_rect()
			apply_limit(limit_rect)
			return

func apply_limit(rect):
	if rect == null:
		return
	limit_top = rect.position.y
	limit_bottom = rect.position.y + rect.size.y
	#limit_right = rect.position.x + rect.size.x
	#limit_left = rect.position.x

func apply_shake(strength, speed, duration):
	if not enable_screen_shake:
		return
	$ShakeTimer.wait_time = speed
	$ShakeTimer.start()
	$ShakeDurationTimer.wait_time = duration
	$ShakeDurationTimer.start()
	shake_strength = strength

func _on_ShakeTimer_timeout():
	set_offset(start_offset + Vector2(randf_range(-1.0, 1.0) * shake_strength, (randf_range(-1.0, 1.0) * shake_strength)))


func _on_ShakeDurationTimer_timeout():
	$ShakeTimer.stop()
	offset = start_offset

func pause():
	$ShakeTimer.paused = true
	
func unpause():
	$ShakeTimer.paused = false


func _on_player_hit():
	apply_shake(4.2, 0.1, 0.5)
