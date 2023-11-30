extends Block

var can_jump = true

func _ready():
	name_of_block = "jump"
	scene_of_block = load("res://scenes/blocks/jump.tscn")
	texture_of_btn = load("res://assets/Pixel Adventure 1/Free/Traps/Trampoline/Idle.png")
	
	add_to_group(name_of_block)


func _on_PlayerDetection_area_entered(area):
	if !edit_mode_enabled and area.get_parent().is_in_group("player") and can_jump:
		can_jump = false
		$AnimationPlayer.play("Jump")
		area.get_parent().position = self.position - Vector2(0,1)
		area.get_parent().jump()
		$TimerResetJump.start()


func _on_TimerResetJump_timeout():
	can_jump = true
