extends Node2D

# A door should unlock when all enemies are gone.
# Therefor i made this variable, to keep track.
var enemies_alive = 0

# This variable makes sure that i can remeber which side a door must 100% spawn locked
# for simplisity it will use "l", "r", "u", "d". (the first letter of the door)
var last_door_position = 3


# Keeps track of the locked doors and the visible doors
export var left_door_locked   = true
export var right_door_locked  = true
export var up_door_locked     = true
export var down_door_locked   = true

export var left_door_visible  = false
export var right_door_visible = false
export var up_door_visible    = false
export var down_door_visible  = false

# Makes it easier and faster to refer to the player
onready var player = $player

# This functionmakes the door the player walked through lock and returns which door it is
# It converts the letters to numbers. 
# The value is choosen by these numbers:
# Left  = pos 0
# Right = pos 1
# Up    = pos 2
# Down  = pos 3
func lock_last_door():
	if last_door_position == 0:
		left_door_locked = true
		return 0
	if last_door_position == 1:
		right_door_locked = true
		return 1
	if last_door_position == 2:
		up_door_locked = true
		return 2
	if last_door_position == 3:
		down_door_locked = true
		return 3

func unlock_doors():
	var x = [left_door_locked, right_door_locked, up_door_locked, down_door_locked]
	var y = [left_door_visible, right_door_visible, up_door_visible, down_door_visible]
	for i in [0, 1, 2, 3]:
		if i != last_door_position:
			if y[i]:
				x[i] = false
				print(x[i])
		else:
			x[i] = true
			print(x[i])


func lock_doors():
	left_door_locked  = true
	right_door_locked = true
	up_door_locked    = true
	down_door_locked  = true

# Spawn doors is used every time a new room is generated. It will place a door at a
# random position, but noth the door the player just went through.
func spawn_doors():
	# This uses the lock_last_door to remember which door that should alwasy be locked
	randomize()
	var locked_door = lock_last_door()
	
	# This variable sets a random number between 0, 3
	# This will be used to place a door at a random position when creating a new room
	var randPos = int(rand_range(0, 4))
	print(randPos, locked_door) # Debug
	
	# If the door this function will place is placed on the door the player just walked through
	# that would come with some problems: would look weird, it can make the hitbox system fail.
	# Therefor i made a while loop that ensures that the door is placed in a fitting position.
	# It chooses a new door if the door was originally going to replace the door the player
	# just went through
	while locked_door == randPos:
		randPos = int(rand_range(0, 4))
		print(randPos) # Debug
	
	
	right_door_visible = false
	left_door_visible  = false 
	down_door_visible  = false
	up_door_visible    = false
	
	
	if randPos == 0:
		left_door_visible = true
	if randPos == 1:
		right_door_visible = true
	if randPos == 2:
		up_door_visible = true
	if randPos == 3:
		down_door_visible = true
	
	if locked_door == 0:
		right_door_visible = true
	if locked_door == 1:
		left_door_visible = true
	if locked_door == 2:
		down_door_visible = true
	if locked_door == 3:
		up_door_visible = true
	
	lock_doors()
	

func spawn_enemies():
	pass

func make_new_room():
	
	#Game.increase_highscore(1)
	#print(Game.data)
	
	#Game.save_data()
	spawn_doors()


# This function is only used once: When the player enters the game.
# It should make a room with only the "up_door"/door at the top visible.
func make_start_room():
	left_door_visible  = false
	right_door_visible = false
	up_door_visible    = true
	down_door_visible  = false


func _on_door_left_door_entered():
	last_door_position = 1
	make_new_room()

func _on_door_right_door_entered():
	last_door_position = 0
	make_new_room()

func _on_door_down_door_entered():
	last_door_position = 3
	make_new_room()

func _on_door_up_door_entered():
	last_door_position = 2
	make_new_room()


func _process(delta):
	if $enemies.get_child_count() == 0:
		unlock_doors()
