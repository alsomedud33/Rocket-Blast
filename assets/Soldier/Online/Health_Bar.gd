extends ProgressBar

var pre_value = value
func _on_Health_Bar_value_changed(value):
	if value < pre_value:
		$AnimationPlayer.play("Shake")
	pre_value = value
