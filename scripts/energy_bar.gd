extends Control

@onready var default_outline_color = $Outline.color

func _ready():
	set_progress(1)

func set_progress(value : float):
	if value == $ProgressBar.value:
		push_warning("Called set progress on Energy bar without value change")
		return
	if $ProgressBar.value - value < 0.001:
		return
	if value > $ProgressBar.value:
		$Outline.color = Color.GREEN
	else:
		$Outline.color = Color.RED
	$OutlineFlashTimer.start()
	$ProgressBar.value = value
	$ValueLabel.text = "%d%%" % int(value * 100)
	


func _on_outline_flash_timer_timeout():
	$Outline.color = default_outline_color
