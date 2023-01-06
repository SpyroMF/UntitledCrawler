extends Node2D

signal door_ready

signal left_door_entered
signal right_door_entered
signal up_door_entered
signal down_door_entered


onready var door_left  = $DoorLeft
onready var door_right = $DoorRight
onready var door_up    = $DoorUp
onready var door_down  = $DoorDown

onready var door_left_hitbox  = $DoorLeft/HB/CS
onready var door_right_hitbox = $DoorRight/HB/CS
onready var door_up_hitbox    = $DoorUp/HB/CS
onready var door_down_hitbox  = $DoorDown/HB/CS

#var left_door_visible
#var right_door_visible
#var up_door_visible
#var down_door_visible
#
#var left_door_locked
#var right_door_locked
#var up_door_locked
#var down_door_locked

func update_doors():
	
	door_left.visible  = get_parent().left_door_visible
	door_right.visible = get_parent().right_door_visible
	door_up.visible    = get_parent().up_door_visible
	door_down.visible  = get_parent().down_door_visible
	
	door_left_hitbox.visible  = get_parent().left_door_locked
	door_right_hitbox.visible = get_parent().right_door_locked
	door_up_hitbox.visible    = get_parent().up_door_locked
	door_down_hitbox.visible  = get_parent().down_door_locked
	

func _ready():
	update_doors()

func _process(delta):
	update_doors()

func check_player(body):
	if body.has_meta("player"):
		if body.get_meta("player") == true:
			return true
	return false

func door_up_entered(body):
	if check_player(body) and door_up_hitbox.visible and door_up.visible:
		print("door u")
		emit_signal("up_door_entered")

func door_down_entered(body):
	if check_player(body) and door_down_hitbox.visible and door_down.visible:
		print("door d")
		emit_signal("down_door_entered")

func door_left_entered(body):
	if check_player(body) and door_left_hitbox.visible and door_left.visible:
		print("door l")
		emit_signal("left_door_entered")

func door_right_entered(body):
	if check_player(body) and door_right_hitbox.visible and door_right.visible:
		print("door r")
		emit_signal("right_door_entered")


