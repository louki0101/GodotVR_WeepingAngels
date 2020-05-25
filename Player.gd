extends KinematicBody

const MOVEMENT_SPEED = 300
const STRAFE_SPEED = 100
const CONTROLLER_DEADZONE = 0.1

onready var left_hand = $OVRFirstPerson/Left_Hand
onready var right_hand = $OVRFirstPerson/Right_Hand
onready var headset = $OVRFirstPerson/ARVRCamera

var joy_dir_pressed = false


func _ready():
	pass





func _process(delta):
	# Directional movement
	# --------------------
	# NOTE: you may need to change this depending on which VR controllers
	# you are using and which OS you are on.
	
	var joystick_vector = Vector2(-right_hand.get_joystick_axis(1), 0)
	
	if joystick_vector.length() < CONTROLLER_DEADZONE:
		joystick_vector = Vector2(0, 0)
	else:
		joystick_vector = joystick_vector.normalized() * ((joystick_vector.length() - CONTROLLER_DEADZONE) / (1 - CONTROLLER_DEADZONE))
		
		
	var forward_direction = headset.global_transform.basis.z.normalized()
	var right_direction = headset.global_transform.basis.x.normalized()
	
	var movement_vector = (joystick_vector).normalized()
	
	var movement_forward = forward_direction * movement_vector.x * delta * MOVEMENT_SPEED
	var movement_right = right_direction * movement_vector.y * delta * STRAFE_SPEED
	
	movement_forward.y = 0
	movement_right.y = 0
	
	#print(Input.get_action_strength("turn_right"))
	
	if movement_right.length() > 0 or movement_forward.length() > 0:
		#get_parent().translate(movement_right + movement_forward)
		move_and_slide(movement_right + movement_forward, Vector3(0,1,0))
		
	# --------------------
	
	


func _on_Right_Hand_button_pressed(button):
	print(button)


func _on_Right_Hand_turn_pressed(controller, stick_right):
	if stick_right:
		rotate_y(45)
	else:
		rotate_y(-45)
		


func death():
	print('player died')
	$AnimationPlayer.play("Death")
	#get_tree().paused = true

func win():
	$AnimationPlayer.play("Win")
