extends Node2D

# This whole code is just for the aiming when the player uses the slingshot.
var mousepos = Vector3(0, 0, 0)
func _process(delta):
	mousepos = get_global_mouse_position() # Finds the mouse position relative to the window
	self.look_at(mousepos) # Rotates this invisible bullet aim thing. (Its called an empty in unity i think)
