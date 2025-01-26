extends CanvasLayer

func _process(delta: float) -> void:
	%DistanceLabel.text = "Distance: %.2fm" % (Player.traveled_distance / 10)
