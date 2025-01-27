extends CanvasLayer

var best_distance := 0.0

func _ready():
	if FileAccess.file_exists("Highscore.sav"):
		var file = FileAccess.open("Highscore.sav", FileAccess.READ)
		best_distance = file.get_float()
		file.close()
	%BestDistanceLabel.text = "Highscore: %.2fm" % (best_distance / 10)

func _process(delta: float) -> void:
	%DistanceLabel.text = "Distance: %.2fm" % (Player.traveled_distance / 10)


func _on_player_power_changed(new_value):
	$EnergyBar.set_progress(new_value)


func _on_retry_button_button_down():
	get_tree().reload_current_scene()


func _on_player_died():
	if Player.traveled_distance > best_distance:
		best_distance = Player.traveled_distance
		%BestDistanceLabel.text = "Highscore: %.2fm" % (best_distance / 10)
		var file = FileAccess.open("Highscore.sav", FileAccess.WRITE)
		file.store_float(best_distance)
		file.close()
	$GameOverScreen.show()
