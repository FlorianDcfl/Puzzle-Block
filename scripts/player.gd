tool
extends KinematicBody2D

var TARGET_FPS = 1
var motion = Vector2()
var speed = 115
var jump_force = 500 #saut de 3 cases (précédente valeur 332)
var gravity = 10

export var go_left : bool

onready var raycast_size = $RayCast.cast_to.x

var dir = 1
var initial_dir : int

var can_move = false
var start_pos = Vector2()


func _ready():
	stop()
	start_pos = global_position
	if go_left:
		reverse()
	$Idle.flip_h = dir < 0
	initial_dir = dir



func _physics_process(delta):
	if Engine.editor_hint:
		$Idle.flip_h = go_left
	else:
		if can_move:
			$Run.flip_h = dir < 0
			motion.x = speed * dir
			if $RayCast.is_colliding():
				reverse()
				if $RayCast.get_collider().has_method("is_hit"):
					$RayCast.get_collider().is_hit()
			motion.y += gravity
			
			#detection avec les blocs effritables
			for i in get_slide_count():
				var collision = get_slide_collision(i)
				if collision.collider.has_method("is_hit"):
					collision.collider.is_hit()
		else:
			motion = Vector2.ZERO

		motion = move_and_slide(motion, Vector2.UP)

func move():
	can_move = true
	$AnimationPlayer.play("Run")


func stop():
	can_move = false
	$AnimationPlayer.play("Idle")


func reset():
	stop()
	if dir != initial_dir:
		reverse()
	self.global_position = start_pos


func reverse():
	dir = dir * -1
	if dir == -1:
		$RayCast.cast_to.x = -raycast_size
	else :
		$RayCast.cast_to.x = raycast_size


func jump():
	motion.y = -jump_force
