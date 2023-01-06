extends Node2D

onready var bullet_spawn = $player/bullet_spawn_rotator/bullet_spawn
onready var bullet_spawn_rotator = $player/bullet_spawn_rotator

onready var UI = $player/CanvasLayer/GAMEUI

export var speed = 50
export var speed_multiplier = 1

export var dash_strength = 1

export var damage = 1
export var damage_multiplier = 1

export var max_health = 3
export var health = 3

export var bullet_speed = 50

onready var player = $player

var max_dashes = 3
var dashes_left = max_dashes
var dash_reload_time = 5

var slingshot_automatic = true
var slingshot_cooldown = 0.7
var slingshot_bullet_size = 1
var slingshot_ready = true


var in_dash = false

var velocity = Vector2()

func _ready():
	set_meta("player", true)
	player.set_meta("player", true)
	speed = speed * 100

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
	
	
	if health <= 0:
		get_tree().change_scene("res://menus/death.tscn")


func _physics_process(delta):
	get_input()
	#player.move_and_slide(velocity * delta)
	velocity = player.move_and_slide(velocity * delta)
	for i in player.get_slide_count():
		var collision = player.get_slide_collision(i)
		#print("I collided with ", collision.collider.name)
		if collision != null:
			if !invincible and collision.collider.has_meta("enemy"):
				invincible = true
				health -= collision.collider.get_meta("damage")
				print("Health: ", health)
				yield(get_tree().create_timer(0.7), "timeout")
				invincible = false
