extends Area2D

var velocity : Vector2
var speed = 150
var dir = 1

func _ready():
	if dir == -1:
		$Sprite.flip_h = true
	$AnimationPlayer.play("turn_on")

	velocity = Vector2(speed, 0)


func _physics_process(delta):
	position += velocity * delta * dir


func _on_Saw_body_entered(body):
	if body.is_in_group("player"):
		get_tree().get_current_scene().reset_level()
