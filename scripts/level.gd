extends Node2D

signal send_available_blocks

var random = RandomNumberGenerator.new()

export var show_grid = true
export var delete_blocks = false

var dictionary_of_editable_blocks : Dictionary

var correct_jump_positions : Array
var correct_reverse_positions : Array

var nb_of_reset : int
var nb_of_block_editable : int
var nb_of_solutions_available : int


func _ready():
#warning-ignore:return_value_discarded
	self.connect("send_available_blocks", $EditMenu, "on_receive_available_blocks")
	
	self.get_blocks_in_level()
	
	nb_of_solutions_available = (correct_jump_positions + correct_reverse_positions).size() - 1
	
	if delete_blocks:
		for block in $Blocks.get_children():
			block.queue_free()


func _draw():
	if show_grid:
		var size = get_viewport_rect().size
		for i in range(0, int((size.x) / 32)):
			draw_line(Vector2(i * 32, size.y), Vector2(i * 32, 0), "e0e0e0")
		for i in range(0, int((size.y) / 32)):
			draw_line(Vector2(size.x, i * 32), Vector2(0, i * 32), "e0e0e0")


func get_blocks_in_level():
	for block in $Blocks.get_children():
		if block.name_of_block == "jump":
			correct_jump_positions.append(block.position)
		if block.name_of_block == "reverse":
			correct_reverse_positions.append(block.position)
		#STORE IN DICTIONARY_OF_EDITABLE_BLOCKS DICTIONNARY, THEIR NAME, SCENE AND TEXTURE_BTN PROPERTIES AS THEIR NB OF USE 
		dictionary_of_editable_blocks[block.name_of_block] = {"scene":block.scene_of_block, "texture_btn": block.texture_of_btn, "nb_use": get_tree().get_nodes_in_group(block.name_of_block).size()}

	#SEND DICTIONARY_OF_EDITABLE_BLOCKS DICTIONNARY AT EDIT_HUD SCRIPT
	emit_signal("send_available_blocks", dictionary_of_editable_blocks)


func start_level():
	for player in $Players.get_children():
		player.move()
	for btn in $EditMenu/HBoxContainer.get_children():
		btn.disabled = true
	for block in $Blocks.get_children():
		block.can_be_edit = false


func reset_level():
	nb_of_block_editable = 0
	for player in $Players.get_children():
		if player.can_move:
			nb_of_reset += 1
		player.reset()
	for btn in $EditMenu/HBoxContainer.get_children():
		btn.disabled = false
	for block in $Blocks.get_children():
		if block.soluce_enable:
			block.can_be_edit = false
		else:
			block.can_be_edit = true
			nb_of_block_editable += 1
	for trap in $Traps.get_children():
		if trap.is_in_group("crumbling"):
			trap.destroying(false)
		if trap.is_in_group("spikes_of_pressure_plate"):
			for s in trap.get_children():
				if s.is_in_group("spike"):
					s.enable(s.initial_state)
		if trap.is_in_group("gun"):
			trap.kill_saw_children()
	if nb_of_reset >= 2 and nb_of_block_editable > 0 and nb_of_solutions_available > 0:
		$GameMenu.btn_soluce.disabled = false


func enable_soluce():
	#REVEAL GOOD POSITION OF ONE BLOCK
	var read_secund_loop = true
	if nb_of_solutions_available > 0:
		nb_of_solutions_available -= 1
		for block_placed in $Blocks.get_children():
			if correct_jump_positions.has(block_placed.position) and block_placed.name_of_block == "jump":
				correct_jump_positions.erase(block_placed.position)
				block_placed.can_be_edit = false
				block_placed.soluce_enable = true
				block_placed.modulate = Color.chartreuse
				read_secund_loop = false
				break
			elif correct_reverse_positions.has(block_placed.position) and block_placed.name_of_block == "reverse":
				correct_reverse_positions.erase(block_placed.position)
				block_placed.can_be_edit = false
				block_placed.soluce_enable = true
				block_placed.modulate = Color.chartreuse
				read_secund_loop = false
				break

		if read_secund_loop:
			for block_placed in $Blocks.get_children():
				if block_placed.can_be_edit :
					if block_placed.name_of_block == "jump" :
						block_placed.position = correct_jump_positions[random.randi_range(0, correct_jump_positions.size() - 1)]
						correct_jump_positions.erase(block_placed.position)
						block_placed.can_be_edit = false
						block_placed.soluce_enable = true
						block_placed.modulate = Color.chartreuse
					if block_placed.name_of_block == "reverse" :
						block_placed.position = correct_reverse_positions[random.randi_range(0, correct_reverse_positions.size() - 1)]
						correct_reverse_positions.erase(block_placed.position)
						block_placed.can_be_edit = false
						block_placed.soluce_enable = true
						block_placed.modulate = Color.chartreuse
					for block_on_same_position in $Blocks.get_children():
						if block_on_same_position.can_be_edit and block_on_same_position.position == block_placed.position:
							block_on_same_position.emit_signal("reset_use", +1, true)
							block_on_same_position.queue_free()
					break

		$GameMenu.btn_soluce.disabled = true
