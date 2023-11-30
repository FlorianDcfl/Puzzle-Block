extends Control

onready var btn_start = $VBoxContainer/HBoxContainer/BtnStart
onready var btn_pause = $VBoxContainer/HBoxContainer/BtnPause
onready var btn_reset = $VBoxContainer/HBoxContainer/BtnReset
onready var btn_soluce = $VBoxContainer/HBoxContainer/BtnSoluce

var is_movable : bool
var click_event_pos : Vector2

func _ready():
	rect_position = Global.game_menu_position_in_next_level


func _process(delta):
	if is_movable :
		rect_global_position.x =  clamp(get_global_mouse_position().x - click_event_pos.x, 0, get_viewport_rect().size.x -150)
		rect_global_position.y =  clamp(get_global_mouse_position().y - click_event_pos.y, 0, get_viewport_rect().size.y - 50)


func _input(event):
	if Input.is_action_just_pressed("start"):
		_on_BtnStart_pressed()
	if Input.is_action_just_pressed("reset"):
		_on_BtnReset_pressed()
	if Input.is_action_just_pressed("pause"):
		_on_BtnPause_pressed()
	if Input.is_action_just_pressed("take_screenshot"):
		var vpt :Viewport = get_viewport()
		var tex : Texture = vpt.get_texture()
		var img : Image = tex.get_data()
		img.flip_y()
		img.save_png("user://screen.png")


func _on_BtnStart_pressed():
	if get_tree().paused:
		get_tree().paused = false
	else:
		get_tree().get_current_scene().start_level()
		btn_soluce.disabled = true


func _on_BtnPause_pressed():
	get_tree().paused = true


func _on_BtnReset_pressed():
	if get_tree().paused:
		get_tree().paused = false
	get_tree().get_current_scene().reset_level()


func _on_BtnSoluce_pressed():
	get_parent().enable_soluce()


func _on_TextureButton_gui_input(event):
	if Input.is_action_just_pressed("click"):
		click_event_pos = $BtnMove.rect_position + event.position
		is_movable = true
	if Input.is_action_just_released("click"):
		click_event_pos = Vector2.ZERO
		is_movable = false
