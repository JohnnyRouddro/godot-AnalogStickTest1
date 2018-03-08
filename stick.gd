extends TouchScreenButton
onready var touchview = get_node("../../TouchView")
export var maxTouch = 3
var touch = []
var stickpos
export var maxDistance = 55
var angle
var mousepos
var touchpos
var coefficient = 4.72
var occupiedIndex
var alreadyPressing = false
func _ready():
	occupiedIndex = maxTouch
	for i in range(maxTouch):
		touch.append({pos = Vector2(), type = ""})
#	mousepos = get_global_mouse_pos()
	touchpos = Vector2(0,0)
	stickpos = get_global_pos()
	angle = (stickpos.angle_to_point(touchpos))
	set_fixed_process(true)
	set_process_input(true)

func _input(event):
	if event.type == InputEvent.SCREEN_DRAG:
		touch[event.index].pos = event.pos
		if is_pressed() and event.index == occupiedIndex or occupiedIndex == maxTouch:
			occupiedIndex = event.index
			touchpos = touch[occupiedIndex].pos
			touch[occupiedIndex].type = "stick"
		else:
			touch[event.index].type = "view"


func _fixed_process(delta):
#	var mousepos = get_global_mouse_pos()
	angle = (stickpos.angle_to_point(touchpos))
	if is_pressed():
		if stickpos.distance_to(touchpos) < maxDistance:
			set_global_pos(touchpos)
		else:
			var limit = Vector2(maxDistance*cos(coefficient-angle), maxDistance*sin(coefficient-angle))
			set_global_pos(limit+stickpos)
	else:
		set_global_pos(stickpos)



func _on_TouchScreenButton_released():
	occupiedIndex = maxTouch
