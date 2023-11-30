extends Area2D

export(String, FILE) var next_level


func _on_Finish_body_entered(body):
	if body.is_in_group("player"):
		Global.game_menu_position_in_next_level = get_parent().get_node("GameMenu").rect_position
		if next_level == "":
			get_tree().reload_current_scene()
		else:
			get_tree().change_scene(next_level)
