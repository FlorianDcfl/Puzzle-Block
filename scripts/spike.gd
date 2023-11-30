tool
extends Area2D

var initial_state

export var activate = true

func _ready():
	initial_state = activate
	enable(activate)



func _process(_delta):
	if Engine.editor_hint:
		$Sprite1.visible = activate
		$Sprite2.visible = activate


func _on_Spikes_body_entered(body):
	if body.is_in_group("player") and activate:
		get_tree().get_current_scene().reset_level()


func enable(state):
	if state:
		$AnimationPlayer.play("Pull up")
		activate = true
	if !state:
		$AnimationPlayer.play("Pull down")
		activate = false
