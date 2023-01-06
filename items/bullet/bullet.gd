extends KinematicBody2D

export var bullet_speed = 100
export var bullet_size = 1

export var explodeing_bullet = false
export var bouncing_bullet = false

export var max_bounces = 1
var bounces_left = max_bounces

var velocity = Vector2()


func _ready():
	bullet_speed *= 10000
	set_meta("bullet", true)
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()

func _physics_process(delta):
	
	velocity = Vector2(1, 0).rotated(rotation) * bullet_speed * delta
	velocity = move_and_slide(velocity * delta)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision != null:
			yield(get_tree().create_timer(0.1), "timeout")
			queue_free()
