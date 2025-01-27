extends CanvasLayer


func _process(delta: float) -> void:
	%DistanceLabel.text = "Distance: %.2fm" % (Player.traveled_distance / 10)


func _on_player_power_changed(new_value):
	$EnergyBar.set_progress(new_value)
