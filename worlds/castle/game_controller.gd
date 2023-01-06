extends Node2D

# A door should unlock when all enemies are gone.
# Therefor i made this variable, to keep track.
var enemies_alive = 0

# This variable makes sure that i can remeber which side a door must 100% spawn locked
# for simplisity it will use "l", "r", "u", "d". (the first letter of the door)
var score = 0

# Keeps track of the locked doors and the visible doors
export var left_door_locked   = true
export var right_door_locked  = true
export var up_door_locked     = true
export var down_door_locked   = true

export var left_door_visible  = true
export var right_door_visible = true
export var up_door_visible    = true
export var down_door_visible  = true

# This dictionary is used to save the different enemy clusters. 
# It is named with like this cluster_d[difficulty]_n[id], where the number behind "n" has the id of the enemy cluster, 
# and the number behind d "d" has its difficulty. it has a sub dictionary for each difficulty.
# The upside of this method is that  makes it easy to add new enemies and stuff,
# While the downside is that there is a limit to the games diversity. 
onready var enemy_clusters = {
	# Easy tutorial enemies
	"1":{
		"cluster_d1_n1": "res://enemy_clusters/cluster_d1_n1.tscn",
		"cluster_d1_n2": "res://enemy_clusters/cluster_d1_n2.tscn",
		"cluster_d1_n3": "res://enemy_clusters/cluster_d1_n3.tscn",
		
	},
	# The tutorial boss
	"2":{
		"cluster_d2_n1": "res://enemy_clusters/cluster_d2_n1.tscn",
	},
	
}


onready var player = $player.player

var in_starter_room = true

var door_went_through: int

# This function makes it easier to invert where the door spawns.
# Upsides is that it will make the code much cleaner and readable.
# Downsides is that it is not that much used.
func invert_door_position(door_position: int):
	if door_position == 2:
		return 3
	if door_position == 3:
		return 2
	if door_position == 0:
		return 1
	if door_position == 1:
		return 0

# This function disables/enables the hitbox that checks if a player
# has hit the door. This makes it much more readable than if i didn't use it.
func locked_doors(left: bool, right: bool, up: bool, down: bool):
	left_door_locked = left
	right_door_locked = right
	up_door_locked = up
	down_door_locked = down

# This function works in the same way as the last, the difference is 
# that it makes the door invisible, and since the hitboxes of the
# door is children of the door, they also get disabled.
func visible_doors(left: bool, right: bool, up: bool, down: bool):
	left_door_visible   = right
	right_door_visible  = left
	up_door_visible     = up
	down_door_visible   = down


# This function is heavily dependent on the "enemy_cluster" dictionary.
# It uses it to select a random enemy cluster at the right difficulty 
# and spawns it in.
func spawn_enemy_cluster(difficulty: int):
	
	var count = enemy_clusters[str(difficulty)].size()
	
	
	var selected_enemycluster = enemy_clusters[str(difficulty)][
		"cluster_d"+
		str(difficulty)+
		"_n"+str(int(rand_range(1,count+1)))
		]
	
	print(selected_enemycluster)
	
	var scene = load(selected_enemycluster)
	var cluster = scene.instance()
	$enemies.add_child(cluster)


# This function only puts a door that is not locked in the "up" position.
# One negative with this method is that because it adds a point for each level
# the player gets one free point. But i am thinking of adding another score system
# if i continue with this project.
func start():
	locked_doors(false, false, true, false) # False = locked
	visible_doors(false, false, true, false)

# This function uses the score to set the difficulty
func get_difficulty(score):
	var difficulty: int
	
	if score < 10:
		return 1
	elif score >= 10:
		return 2
	



# new_room()'s job is to make doors, and keep track of the score and highscore
var current_door
func new_room():
	score += 1
	
	# If the score is bigger than the highscore it will make the highscore equal to
	# the score and save it.
	if score > Game.player["highscore"]:
		Game.player["highscore"] = score
		Game.save_data()
	
	print("Highscore: ", Game.player["highscore"])
	print(score)
	in_starter_room = false
	print("Making a new room...")
	randomize()
	
	# Inverts door position
	# Example: if the door was supposed to spawn upwards, 
	# it would make the door be spawned downward
	door_went_through = invert_door_position(door_went_through)
	
	
	visible_doors(false, false, true, true)
	locked_doors(false, false, false, false) # False = locked
	spawn_enemy_cluster(get_difficulty(score))

# Unlocks the top door.
func unlock_door():
	locked_doors(false, false, true, false) # False = locked

# These functions are connected to the door hitboxes and trigger when
# the player hits them. This is really efficient and makes it easy to
# control door functions.
func _on_door_left_door_entered():
	door_went_through = 0
	player.position.x -= 280
	new_room()

func _on_door_right_door_entered():
	door_went_through = 1
	player.position.x += 280
	new_room()

func _on_door_up_door_entered():
	door_went_through = 2
	player.position.y += 120
	new_room()

func _on_door_down_door_entered():
	door_went_through = 3
	player.position.y -= 120
	new_room()



func _ready(): # Runs when the scene is loaded
	Game.load_data() #loads all the important save data
	start() # places the starter-room

func _process(delta): # Runs every frame. See player/player.gd to read more about this function.
	# Here i make sure the upward door stays closed until all the enemies are killed
	if $enemies.get_child_count() == 0:
		unlock_door()
