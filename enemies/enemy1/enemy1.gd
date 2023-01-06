extends KinematicBody2D

onready var world = get_parent().get_parent().get_parent()

export var speed = 20
export var health = 2
export var size = 1
export var damage = 1
var player: Object

func find_player():
	for child in world.get_children():
		if child.has_meta("player"):
			var c = child
			for child1 in c.get_children():
				if child1.has_meta("player"):
					return child1

func _ready():
	scale.x = size
	scale.y = size
	player = find_player()
	set_meta("enemy", true)
	set_meta("damage", damage)

var velocity = Vector2(0, 0)

func _physics_process(delta):
	player = find_player()
	position = position.move_toward(player.position, speed * delta)
	
	velocity = move_and_slide(velocity * delta)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision != null:
			if collision.collider.has_meta("bullet"):
				if health <= 0:
					#var blood = load("res://effects/blood_splatter.tscn")
					#var blood_instance = blood.instance()
					#blood_instance.position = self.global_position
					#get_parent().add_child(blood_instance)
					queue_free()
				
				health -= player.get_parent().damage
				collision.collider.queue_free()
				
