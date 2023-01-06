extends Node2D


func _physics_process(delta):
	for i in range(get_child_count()):
		if get_child(i).get_child_count() == 0:
			get_child(i).queue_free()
