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
	AudioController.play_chill()
	$GameOverScreen.show()
	$GetHighscoresReqest.request("https://firestore.googleapis.com/v1/projects/gunkey-6a1db/databases/(default)/documents/feline_frontier/highscores")


func _on_get_highscores_reqest_request_completed(result, response_code, headers, body):
	if response_code != 200:
		push_error("Unable to fetch highscores!")
		return
	var data = JSON.parse_string(body.get_string_from_utf8())
	var scores : Array = str_to_var(data["fields"]["entries"]["stringValue"])
	var score_count = scores.size()
	var score_placement := 0
	for score in scores:
		if Player.traveled_distance > score:
			scores.insert(score_placement, snapped(Player.traveled_distance, 0.01))
			break
		score_placement += 1
	if score_placement == score_count:
		scores.append(snapped(Player.traveled_distance, 0.01))
	score_placement += 1
	if score_placement <= 10:
		$GameOverScreen/ScoreResultLabel.text = "Your score: %.2fm (Global #%d)" % [Player.traveled_distance / 10, score_placement]
	else:
		$GameOverScreen/ScoreResultLabel.text = "Your score: %.2fm (Global Top %d%%)" % [Player.traveled_distance / 10,
			 int(float(score_placement) / float(score_count) * 100.0)]
	$GameOverScreen/ScoreResultLabel.show()
	data["fields"]["entries"]["stringValue"] = JSON.stringify(scores)
	$GetHighscoresReqest/PostHighscoresRequest.request("https://firestore.googleapis.com/v1/projects/gunkey-6a1db/databases/(default)/documents/feline_frontier/highscores", \
		[], HTTPClient.METHOD_PATCH, JSON.stringify(data))
	


func _on_post_highscores_request_request_completed(result, response_code, headers, body):
	if response_code != 200:
		push_error("failed to upload higscore!")


func _on_get_top_players_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	pass # Replace with function body.
