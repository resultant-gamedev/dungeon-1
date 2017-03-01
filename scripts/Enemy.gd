
extends KinematicBody2D


func _ready():
	set_fixed_process(true)
	randomize()
	

func _fixed_process(delta):
	var motion = Vector2()
	motion = get_node("../Player").get_pos() - get_pos()
	motion = motion.normalized()
	
	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)	
		
	move(motion)