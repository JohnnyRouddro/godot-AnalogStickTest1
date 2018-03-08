extends Spatial

onready var cam = get_node("cam")
onready var touchView = get_node("../TouchView")
onready var stick = get_node("../Stick/TouchScreenButton")
#onready var left = get_node("../Camera/left")
var cam_rot
var player_rot
var last_angle
export var rotationSpeed = 20
func _ready():
	player_rot = int(rad2deg(get_rotation().y))
	last_angle = player_rot
	cam = get_node("cam");
	if cam.has_method("set_enabled"):
		cam.set_enabled(true);
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	cam.add_collision_exception(self);
	cam.cam_radius = 2.5;
	cam.cam_view_sensitivity = 0
	cam.cam_smooth_movement = true;
	cam.cam_fov = 80.0;
	cam.cam_pitch_minmax = Vector2(100, -80);

	set_fixed_process(true)
	set_process_input(true)

func _input(event):
	if event.is_action_released("key_w") or event.is_action_released("key_a") or event.is_action_released("key_s") or event.is_action_released("key_d"):
		last_angle = player_rot



func _fixed_process(delta):
	
	if touchView.is_pressed():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		cam.cam_view_sensitivity = 0.3
	if not touchView.is_pressed():
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		cam.cam_view_sensitivity = 0
	
	cam_rot = (int(cam.cam_yaw) % 360)
	if cam_rot > 360 or cam_rot < -360:
		cam_rot = 0
	player_rot = (int(rad2deg(get_rotation().y)))
#	print("......")
#	print(cam_rot)
#	print(player_rot)
#	print(stick.angle)
	if stick.is_pressed():
		set_rotation(Vector3(0,stick.angle+deg2rad(cam_rot),0))
		
	if Input.is_key_pressed(KEY_W):
		if Input.is_key_pressed(KEY_A):
			player_rotate(45,delta)
		elif Input.is_key_pressed(KEY_D):
			player_rotate(-45,delta)
		else:
			player_rotate(0,delta)
	elif Input.is_key_pressed(KEY_S):
		if Input.is_key_pressed(KEY_A):
			player_rotate(135,delta)
		elif Input.is_key_pressed(KEY_D):
			player_rotate(-135,delta)
		else:
			player_rotate(180,delta)
	elif Input.is_key_pressed(KEY_A):
		player_rotate(90,delta)
	elif Input.is_key_pressed(KEY_D):
		player_rotate(-90,delta)

func player_rotate(angle,delta):
	if (last_angle-angle) > 180:
		angle = 360-last_angle+angle
	set_rotation_deg(Vector3(0,lerp(player_rot, cam_rot+angle, rotationSpeed*delta),0))


