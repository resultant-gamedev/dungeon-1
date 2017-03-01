
extends KinematicBody2D

var dir = Vector2()

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	move(dir * delta)
	
	if is_colliding():
		var other = get_collider()
		if other.get_name().begins_with("Enemy"):
			other.queue_free()
		queue_free()
	

func _on_Timer_timeout():
	queue_free()
