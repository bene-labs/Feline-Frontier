extends Control

func _ready():
	set_progress(1)

func set_progress(value : float):
	$ProgressBar.value = value
	$ValueLabel.text = "%d%%" % int(value * 100)
