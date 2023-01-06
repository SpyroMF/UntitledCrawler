extends KinematicBody2D


# For info on what onready var does, read the player/player.gd
onready var world = get_parent().get_parent().get_parent()

# For info on what export var does, read the player/player.gd
export var speed = 20
export var health = 2
export var size = 1
export var damage = 1
var player: Object

# Searches the top node of testing_world.tscn to find the player
# This code is not well optimised, this will run ever physics frame,
# but it was the easiest method i could think of at the time when coding this.
func find_player():
	for child in world.get_children():
		if child.has_meta("player"):
			var c = child
			for child1 in c.get_children():
				if child1.has_meta("player"):
					return child1

func _ready(): # Runs when the scene is fully loaded
	scale.x = size
	scale.y = size
	player = find_player()
	set_meta("enemy", true)
	set_meta("damage", damage)

var velocity = Vector2(0, 0)


# The enemy1 "ai" consists of only follow the player.
# The player will take damage when enemy1 hits the player
# This function not coded that well i would say. The code is a bit ugly, but it works.
# If I continue this project i will add more fail checks to make the code more reliable.
func _physics_process(delta):
	player = find_player() # Assigns the player to 
	position = position.move_toward(player.position, speed * delta)
	
	velocity = move_and_slide(velocity * delta)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		
		if collision != null: # this "if" fixes a common crash. (think its a bug with godot)
			if collision.collider.has_meta("bullet"):
				if health <= 0: # if health is lower than 1, remove the enemy
					queue_free()
				health -= player.get_parent().damage
				collision.collider.queue_free()
