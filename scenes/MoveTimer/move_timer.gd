extends Sprite2D

func play(move_duration:float):
	$Timer.frame = 0
	$Timer.play("default",1.0/move_duration)

func _on_timer_animation_finished() -> void:
	$Timer.pause()
