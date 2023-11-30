extends Area2D

export(Array, NodePath) var nodes_inverse_state
export(Array, NodePath) var nodes_enable
export(Array, NodePath) var nodes_desable


func _on_PressurePlate_body_entered(body):
	if body.is_in_group("player") :
		for n in nodes_inverse_state:
			get_node(n).enable(not get_node(n).activate)
		for n in nodes_enable:
			get_node(n).enable(true)
		for n in nodes_desable:
			get_node(n).enable(false) 
