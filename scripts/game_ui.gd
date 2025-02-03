extends CanvasLayer

var best_distance := 0.0
var scores : Array
var score_count := 0
var score_placement := 0

func _ready():
	if FileAccess.file_exists("user://Highscore.sav"):
		var file = FileAccess.open("user://Highscore.sav", FileAccess.READ)
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
		var file = FileAccess.open("user://Highscore.sav", FileAccess.WRITE)
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
	scores = str_to_var(data["fields"]["entries"]["stringValue"])
	score_count = scores.size()
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
	$GetTopPlayersRequest.request("https://firestore.googleapis.com/v1/projects/gunkey-6a1db/databases/(default)/documents/feline_frontier/top_players")


func _on_post_highscores_request_request_completed(result, response_code, headers, body):
	if response_code != 200:
		push_error("failed to upload higscore!")


func _on_get_top_players_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code != 200:
		push_error("Unable to fetch top players!")
		return
	var data = JSON.parse_string(body.get_string_from_utf8())
	if score_placement <= 5:
		$GameOverScreen/EnterInitials.show()
		await $GameOverScreen/EnterInitials/InitialConfirmButton.pressed
		$GameOverScreen/EnterInitials.hide()
		
		for i in range(5, score_placement, -1):
			var prev_best = data["fields"][str(i-1)]["stringValue"]
			data["fields"][str(i)]["stringValue"] = prev_best
		
		data["fields"][str(score_placement)]["stringValue"] = \
		 JSON.stringify({"name": $GameOverScreen/EnterInitials/LineEdit.text,
			"score": snapped(Player.traveled_distance / 10_000, 0.01) })
	var fields = data["fields"]
	var players = [
		JSON.parse_string(fields["1"]["stringValue"]),
		JSON.parse_string(fields["2"]["stringValue"]),
		JSON.parse_string(fields["3"]["stringValue"]),
		JSON.parse_string(fields["4"]["stringValue"]),
		JSON.parse_string(fields["5"]["stringValue"])
	]
	%BestPlayersLabel.text %= [
		players[0]["name"], players[0]["score"],
		players[1]["name"], players[1]["score"],
		players[2]["name"], players[2]["score"],
		players[3]["name"], players[3]["score"],
		players[4]["name"], players[4]["score"],
	]
	%BestPlayersLabel.show()
	$GetTopPlayersRequest/PatchTopPlayersRequest.request("https://firestore.googleapis.com/v1/projects/gunkey-6a1db/databases/(default)/documents/feline_frontier/top_players",
		[], HTTPClient.METHOD_PATCH, JSON.stringify(data))

func _on_line_edit_text_changed(new_text: String) -> void:
	%InitialConfirmButton.disabled = $GameOverScreen/EnterInitials/LineEdit.text == ""


func _on_patch_top_players_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
		if response_code != 200:
			push_error("failed to patch top players!")
			print(body.get_string_from_utf8())
