#warnings-disable
class_name Block
extends Area2D

signal reset_use

var name_of_block : String
var scene_of_block : Object
var texture_of_btn : Object

var soluce_enable : bool

var can_be_edit : bool
var edit_mode_enabled : bool

var is_in_node : bool
var can_be_place : bool

var hard_pos_correction = Timer.new()
var pos_before_selection : Vector2
var has_just_spawned : bool


func _ready():
	self.connect("input_event", self, "on_block_selected")
	
	can_be_edit = true
	
	self.add_child(hard_pos_correction)
	hard_pos_correction.one_shot = true
	hard_pos_correction.connect("timeout", self, "apply_correct_position")


func _process(delta):
	#WHEN THE EDIT MODE IS ENABLE, THE BLOCK CAN BE PLACE IN THE LEVEL AND DOES NOT INTERACT WITH PLAYER
	if edit_mode_enabled:
		position = Vector2(int(get_global_mouse_position().x /32) * 32,int(get_global_mouse_position().y /32) * 32)
		if $RayCast2D.get_collider() != null and $RayCast2D.get_collider().name == "Background" and get_overlapping_bodies().size() == 0 and get_overlapping_areas().size() <= 1:
			self.modulate = Color.white
		else :
			self.modulate = Color.red


func _input(event):
	#PLACE THE BLOCK SELECTED IN THE LEVEL
	if Input.is_action_just_released("click") and edit_mode_enabled:
		hard_pos_correction.start(0.3)
		edit_mode_enabled = false


func on_block_selected(viewport, event:InputEvent, shape_idx):
	if Input.is_action_just_pressed("click") and can_be_edit:
		edit_mode_enabled = true
		pos_before_selection = position


func apply_correct_position():
	#RETURN AT INITIAL POS IF THIS CANNOT BE PLACED
	if !$RayCast2D.is_colliding() or $RayCast2D.get_collider().name != "Background" or get_overlapping_bodies().size() != 0 or get_overlapping_areas().size() > 1:
				#IF BLOCK HAS NOT ALREADY POSED IN LEVEL, DELETE THIS AND REBOOT ITS NB OF USE
				if has_just_spawned:
					emit_signal("reset_use", +1, true)
					queue_free()
				else:
					position = pos_before_selection
					self.modulate = Color.white
	has_just_spawned = false
