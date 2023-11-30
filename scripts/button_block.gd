extends TextureButton

var nb_of_use : int
var scene_of_block_selected : PackedScene
var blocks_parent_node : Object


func _ready():
	$NbUtilisation.text = str(nb_of_use)


func _on_ButtonModel_button_down():
	#CREATE AN INSTANCE NODE OF BLOCK SELECTED
	var scene_selected = scene_of_block_selected.instance()

	if nb_of_use > 0:
		set_nb_of_use(-1, true)
		
		#ENABLE THE EDIT MODE OF INSTANCIATED NODE
		scene_selected.can_be_edit = true
		scene_selected.edit_mode_enabled = true
		scene_selected.has_just_spawned = true

		scene_selected.connect("reset_use", self, "set_nb_of_use")
		
		scene_selected.position = Vector2(int(get_global_mouse_position().x /32) * 32,int(get_global_mouse_position().y /32) * 32)
		
		blocks_parent_node.call_deferred("add_child", scene_selected)


func set_nb_of_use(nb, increment):
	if increment :
		nb_of_use += nb
	else:
		nb_of_use = nb
	$NbUtilisation.text = str(nb_of_use)

