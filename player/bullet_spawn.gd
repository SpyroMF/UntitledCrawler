extends Node2D

var mousepos = Vector3(0, 0, 0)
func _process(delta):
	mousepos = get_global_mouse_position()
	self.look_at(mousepos)
