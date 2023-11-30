extends MarginContainer

onready var btn_block = preload("res://scenes/hud/button_block.tscn")

var dictionary_of_blocks : Dictionary

var current_level : Node


func _ready():
	if get_tree().get_current_scene().is_in_group("levels"):
		current_level = get_tree().get_current_scene()


func on_receive_available_blocks(dictionary_of_blocks):
	#CREATE AN INSTANCE OF BUTTON BLOCK SCENE BY DIFFERENT AVAILABLE BLOCKS IN LEVEL AND ASSIGN IT PROPERTIES STORE IN BLOCKS DICTIONNARY
	for block in dictionary_of_blocks:
		var b = btn_block.instance()
		
		#DEFINES WHAT BLOCK WILL BE CREATE WHEN PLAYER WILL CLICK IN THIS BUTTON
		b.scene_of_block_selected = dictionary_of_blocks.get(block).get("scene")
		b.texture_normal = dictionary_of_blocks.get(block).get("texture_btn")
		
		#DEFINES HOW MANY TIMES THE PLAYER WILL BE ABLE TO PLACE THIS BLOCK IN THE LEVEL
		b.nb_of_use = dictionary_of_blocks.get(block).get("nb_use")
		
		b.blocks_parent_node = current_level.find_node("Blocks")
		
		$HBoxContainer.add_child(b)
