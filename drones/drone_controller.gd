extends RigidBody3D


@export var throttle_rate = 1.8
@export var pitch_roll_rate = 0.04
@export var yaw_rate = 0.04
@export var lateral_prop_thrust_ratio = 0.5
@export var can_reverse = false

@onready var fl_prop = get_node("FLProp")
@onready var fr_prop = get_node("FRProp")
@onready var bl_prop = get_node("BLProp")
@onready var br_prop = get_node("BRProp")


func run_propeller(propeller, speed, anticlockwise=true):
	if speed < 0 and not can_reverse: speed = 0
	apply_force(propeller.global_transform.basis.y * speed, propeller.global_position - global_position)
	apply_force(propeller.global_transform.basis.x * speed * lateral_prop_thrust_ratio, propeller.global_position - global_position)
	propeller.get_node("MeshInstance3D2").rotate_y(speed if anticlockwise else -speed)


func _physics_process(delta):
	if Input.is_action_just_pressed("camera_toggle"):
		get_parent().get_node("Camera3D").current = not get_parent().get_node("Camera3D").current
	
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("hud_toggle"):
		get_node("CanvasLayer/HUD").visible = not get_node("CanvasLayer/HUD").visible
	
	if Input.is_action_just_pressed("turtle_toggle") or Input.is_action_just_released("turtle_toggle"):
		can_reverse = not can_reverse
	
	var throttle = Input.get_axis("throttle_down", "throttle_up") * throttle_rate * (Input.get_action_strength("rate_toggle") + 1)
	var pitch = Input.get_axis("pitch_backward", "pitch_forward") * pitch_roll_rate * (Input.get_action_strength("rate_toggle") + 1)
	var roll = Input.get_axis("roll_left", "roll_right") * pitch_roll_rate * (Input.get_action_strength("rate_toggle") + 1)
	var yaw = Input.get_axis("yaw_anticlockwise", "yaw_clockwise") * yaw_rate * (Input.get_action_strength("rate_toggle") + 1)
	
	run_propeller(fl_prop, throttle - yaw - pitch + roll)
	run_propeller(fr_prop, throttle + yaw - pitch - roll, false)
	run_propeller(bl_prop, throttle + yaw + pitch + roll, false)
	run_propeller(br_prop, throttle - yaw + pitch - roll)
