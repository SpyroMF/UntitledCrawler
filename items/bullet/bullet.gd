extends KinematicBody2D

# More info about export var in player/player.gd
export var bullet_speed = 100
export var bullet_size = 1

export var explodeing_bullet = false # not implemented yet.
export var bouncing_bullet = false # not implemented yet.

export var max_bounces = 1 # not implemented yet.
var bounces_left = max_bounces # also not implemented yet.

var velocity = Vector2()

# runs on startup
func _ready():
	bullet_speed *= 10000 # Multiplies the bullet_speed so the exported bullet_speed doesn't need to be so long.
	set_meta("bullet", true) # Sets the metadata to the bullet
	yield(get_tree().create_timer(0.5), "timeout") # Waits in 0.5 seconds then deletes the bullet
	queue_free() # deletes the bullet



# This makes it so the bullet moves with physics in the wanted direction
# and removes it when it hits something.
# This is one of the most efficient methods of doing this, but could make the code more readable.
func _physics_process(delta):
	velocity = Vector2(1, 0).rotated(rotation) * bullet_speed * delta # advanced math
	velocity = move_and_slide(velocity * delta)
	for i in get_slide_count(): # Gets all the nodes that have hit the bullet
		var collision = get_slide_collision(i)
		if collision != null: # fixes a common crash
			yield(get_tree().create_timer(0.1), "timeout") # same as sleep(0.1) in python
			queue_free() # removes the bullet
