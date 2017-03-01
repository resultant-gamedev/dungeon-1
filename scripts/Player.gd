
extends KinematicBody2D

var bullet = preload("res://scenes/Bullet.tscn")

export var MOTIONSPEED = 140

var RayNode
var canshoot = false;
onready var offset = Vector2(0, 0)
onready var relative_mouse_pos = Vector2(0, 0)

func _ready():
	set_fixed_process(true)
	RayNode = get_node("RayCast2D")
	pass

func _fixed_process(delta):
	var motion = Vector2()
	
	if Input.is_action_pressed("ui_up"):
		motion += Vector2(0, -1)
		RayNode.set_rotd(180)
	
	if Input.is_action_pressed("ui_down"):
		motion += Vector2(0, 1)
		RayNode.set_rotd(0)
	
	if Input.is_action_pressed("ui_left"):
		motion += Vector2(-1, 0)
		RayNode.set_rotd(-90)
	
	if Input.is_action_pressed("ui_right"):
		motion += Vector2(1, 0)
		RayNode.set_rotd(90)
		
	if Input.is_action_pressed("Fire") && canshoot == true:
		var player = get_parent().get_node("SamplePlayer")
		var voiceID = player.play("shoot")
		fire()
		
	offset = -get_parent().get_viewport().get_canvas_transform().o * get_node("Camera2D").get_zoom()
	relative_mouse_pos = get_parent().get_viewport().get_mouse_pos() * get_node("Camera2D").get_zoom() + offset

	get_node("ShootDirection").look_at(relative_mouse_pos)
	
	motion = motion.normalized()*MOTIONSPEED*delta
	
	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)	
	
	move(motion)

func fire():
	var bulletInstance = bullet.instance()
	bulletInstance.set_global_pos(get_global_pos())	
	bulletInstance.add_collision_exception_with(self)
	bulletInstance.dir = Vector2(450, 0).rotated(get_node("ShootDirection").get_rot() - deg2rad(90))	
	get_parent().add_child(bulletInstance)	
	get_node("ShootTimer").start()
	canshoot = false;
	
func _on_Timer_timeout():
	canshoot = true;
	
	
	