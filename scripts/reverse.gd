extends Block


func _ready():
	name_of_block = "reverse"
	scene_of_block = load("res://scenes/blocks/reverse.tscn")
	texture_of_btn = load("res://assets/reverse.png")

	add_to_group(name_of_block)


func _on_PlayerDetection_area_entered(area):
	if !edit_mode_enabled and area.get_parent().is_in_group("player"):
		area.get_parent().reverse()
