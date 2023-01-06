extends Node2D

# onready var means it sets the variable when everything is loaded.
# this is needed when refering to an node, outside of a function.
# (nodes are godots version of a gameObject from unity)
# Here i used to refer to the nodes that the bullets will copy the position.
# bullet_spawn is the point where the bullet spawns and the bullet will
# copy the bullet_spawn_rotator's global rotation so that the bullet
# spawns at the right position with the right rotation
onready var bullet_spawn = $player/bullet_spawn_rotator/bullet_spawn
onready var bullet_spawn_rotator = $player/bullet_spawn_rotator

# Here i set the UI to refer to the GAMEUI
onready var UI = $player/CanvasLayer/GAMEUI
onready var player = $player


# Export will make it posible to edit the variables outsid of
# the script, and makes it easier for different scripts to talk to eachother.
export var speed = 50
export var speed_multiplier = 1

export var dash_strength = 1

export var damage = 1
export var damage_multiplier = 1

export var max_health = 3
export var health = 3

export var bullet_speed = 50

var max_dashes = 3
var dashes_left = max_dashes
var dash_reload_time = 5

var slingshot_automatic = true
var slingshot_cooldown = 0.7
var slingshot_bullet_size = 1
var slingshot_ready = true


var in_dash = false

var velocity = Vector2()

func _ready(): # Runs when the scene is fully loaded
	set_meta("player", true)
	player.set_meta("player", true)
	speed = speed * 100


# This function is used to check which buttons are pressed
# It will manage the movement and the figting.
# This function is used in _physics_process(delta)
# The upside of doing this is that it is easy to add new keybinds
# and it is reliable.
# ----------------------------------------------------------------------
# It may take an unnecessary amount of recources to run this every
# physics frame. A fix to this problem would be to use the
# "func _input(event):", it only runs when a mouse moves or a button
# is pressed.
func get_input():
	
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	
	# The dash is used to evade enemies, it should give the player imortality for a few seconds.
	# If the dash button is pressed (wich is assigned to the "L_SHIFT" button), it will run this
	# code. The code starts with setting in dash to true so that the player need to wait for the
	# dash to finish before dashing again. it also need to have dashes left. The dash does also
	# help with a gamebreaking bug where the player can become stuck between enemies and walls.
	if Input.is_action_just_pressed("dash") and !in_dash and dashes_left > 0: 
		# ◤If left-shift is pressed             ◤Dash ready      ◤Have enough dashes left
		
		
		
		dashes_left -= 1 # Removes a dash
		
		print("Dashes left: ",dashes_left)
		
		in_dash = true # Stops function from running 2 times at once
		speed += dash_strength * 10000 # Ups the speed
		player.set_collision_mask_bit(0, false) # Makes it so the player can dash thru enemies
		
		yield(get_tree().create_timer(0.1), "timeout")
		
		speed -= dash_strength * 10000
		in_dash = false
		player.set_collision_mask_bit(0, true)
	
	velocity = velocity.normalized() * speed
	
	# The attack function shoots a "stone" from the players slingshot (Lore wise).
	# When the attack button is pressed (space by default), it will summon a scene
	# called bullet. I have coded this bullet so it will move in a selected direction
	# and delete itself a little bit after it hits something. I have made it remove
	# itself a bit slower because that the enemies getting hit can get som time to register
	# that they have been hit.
	# This function is pretty simple and have minimal impact on the performance.
	if Input.is_action_pressed("attack") and slingshot_ready:
		slingshot_ready = false
		var scene = load("res://items/bullet/bullet.tscn")
		var bullet = scene.instance()
		bullet.rotation_degrees = bullet_spawn_rotator.rotation_degrees
		bullet.position = bullet_spawn.global_position
		bullet.set_meta("shooter", "player")
		bullet.bullet_speed = bullet_speed
		add_child(bullet)
		yield(get_tree().create_timer(slingshot_cooldown), "timeout")
		if slingshot_automatic:
			slingshot_ready = true




export var invincible = false


var recharge_dash_bool = true

# ----------------------------------------------------------------------------------
# The _process(delta) is a godot default and will run one time each frame. It
# has the delta value which is the time it took to render a frame. The delta
# is primarily used to make the game playable at different framerates.
# ----------------------------------------------------------------------------------
# Here i used the _process to update ui and recharge the dash.
# This option for UI updating was unnecessary but time efficient, it will not impact 
# the performance in a gamebreaking way. I could've made a counter instead, but
# that would be overcomplicating the system and would've taken too much time.
func _process(delta):
	UI.health = health
	UI.max_health = max_health
	UI.dash = dashes_left
	UI.max_dash = max_dashes
	UI.score = get_parent().score
	
	
	# Here the code recharges the dash until its full. If there are less dashes left than the max,
	# it will add 1 dash until its full.
	if dashes_left < max_dashes:
		if recharge_dash_bool == true:
			recharge_dash_bool = false
			yield(get_tree().create_timer(dash_reload_time), "timeout")
			dashes_left += 1
			recharge_dash_bool = true
	
	# If the player has 0 health or lower it will change scene to the death menu
	if health <= 0:
		get_tree().change_scene("res://menus/death.tscn")

# ----------------------------------------------------------------------------------
# The physics_process(delta) is a godot default and will run at the same framerate the physics does.
# This is necessary for the physics to work. The developer can choose what framerate the physics will
# be limited to. Right now it is set to 60 physics updates per second.
# ----------------------------------------------------------------------------------
# In this function i put the movement function, wich gets the imput from get_input() and uses it with
# the move_and_slide() function. The move_and_slide() function is used to move the time with a Vector3
# variable. It will move the player until it hits something, then slide in the chosen direction.
# This was one of the most efficient methods to do movement while still keeping it simple.
func _physics_process(delta):
	get_input() # In this situation it will update the velocity which is a Vector3 variable, to move.
	
	velocity = player.move_and_slide(velocity * delta) 
	# Here while the variable is assigned, godot will run the built in function move_and_slide, while
	# assigning its value to the velocity for potential later usage. It also takes 1 variable which
	# desides the speed and direction. I have multiplied it with delta, so it will move at the same
	# speed per second at any framerate.
	
	# This for loop pulls all the collisions that the player has and the collided object properties.
	# The code for this may look a little ugly, but it works.
	for i in player.get_slide_count():
		var collision = player.get_slide_collision(i)
		if collision != null:
			if !invincible and collision.collider.has_meta("enemy"):
				invincible = true
				health -= collision.collider.get_meta("damage")
				print("Health: ", health)
				yield(get_tree().create_timer(0.7), "timeout")
				invincible = false
