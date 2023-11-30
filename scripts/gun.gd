tool
extends Area2D


export var shoot_left : bool

export var projectile_speed = 150


func _ready():
	$Sprite.flip_v = shoot_left


func _physics_process(delta):
	if Engine.editor_hint:
		$Sprite.flip_v = shoot_left



func enable(state):
	if state:
		var saw = load("res://scenes/traps/saw.tscn").instance()
		saw.speed = projectile_speed
		call_deferred("add_child",saw)
		if shoot_left:
			saw.dir = -1
		else:
			saw.dir = 1

func kill_saw_children():
	for child in get_children():
		if child.is_in_group("saw"):
			child.queue_free()
