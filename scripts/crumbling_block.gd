extends StaticBody2D

func is_hit():
	$TimerDestruction.start()


func _on_TimerDestruction_timeout():
	destroying(true)


func destroying(destroy):
	if destroy:
		$CollisionShape2D.set_deferred("disabled", true)
		$Sprite.visible = false
	else:
		$CollisionShape2D.set_deferred("disabled", false)
		$Sprite.visible = true
		$TimerDestruction.stop()
