extends Control


# When the play again button is pressed it loads back into the main world
func _on_play_again_pressed():
	get_tree().change_scene("res://worlds/castle/testing_world.tscn")

# Not implemented yet
func _on_quit_pressed():
	pass
