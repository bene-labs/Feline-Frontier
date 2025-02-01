extends Node2D

const MUSIC_FADE_IN_DURATION = 2.5
const MUSIC_FADE_OUT_DURATION = 2.5


#var is_stream_1_playing := false
#@onready var fade_in_tween :=  get_tree().create_tween()
#@onready var fade_out_tween := get_tree().create_tween()
#var fade_in_stream : AudioStreamPlayer
#var fade_out_stream : AudioStreamPlayer

enum MusicId {
	CHILL,
	INTENSE
}


func play_chill():
	$AnimationPlayer.play("play_chill")
	
func play_intense():
	$AnimationPlayer.play("play_intense")


#func transition_to(id: MusicId):
	#fade_in_stream = $AudioStreamPlayer2 if is_stream_1_playing else $AudioStreamPlayer1
	#fade_out_stream = $AudioStreamPlayer1 if is_stream_1_playing else $AudioStreamPlayer2
	#match id:
		#MusicId.CHILL:
			#fade_in_stream.stream = space_music
		#MusicId.INTENSE:
			#fade_in_stream.stream = intense_music
	#is_stream_1_playing = not is_stream_1_playing
	#fade_out_music()
	#fade_in_music()
	#fade_in_stream.play()
#
#
#func fade_in_music(target_volume:= 1.0) -> void:
	#fade_in_tween.kill()
#
	#fade_in_tween.tween_method(
		#_interpolate_music_volume_increase,
		#0.0, target_volume,
		#MUSIC_FADE_IN_DURATION
	#)
	#
	#fade_in_tween.play()
#
#
#func fade_out_music(start_volume:= 1.0) -> void:
	#fade_out_tween.kill()
#
	#fade_out_tween.tween_method(
		#_interpolate_music_volume_decrease,
		#start_volume, 0.0,
		#MUSIC_FADE_OUT_DURATION, #Tween.TRANS_QUAD, Tween.EASE_IN_OUT
	#)
	#
	#fade_out_tween.play()
#
#
#func _interpolate_music_volume_increase(volume_linear: float) -> void:
	#fade_in_stream.volume_db = linear_to_db(volume_linear)
	#
#
#func _interpolate_music_volume_decrease(volume_linear: float) -> void:
	#fade_out_stream.volume_db = linear_to_db(volume_linear)
