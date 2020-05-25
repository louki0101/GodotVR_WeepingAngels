extends KinematicBody

#angels enter 'idle' state when they cannot see the player
#--for now in idle state they will just sit still
#--if they see the player, move into the attack state
#--potentially return to original position

#angels enter 'attack' state when they can see the player
#-- looks at player
#--if near enough to player, player loses
#--if player looks at angel while in attack state, they freeze
#--move at player while in attack and not frozen
#--if they no longer see the player move back to idle state

var state = 'idle'
var is_frozen = false

var is_eating = false

const MOVE_SPEED = 200
var start_position
onready var player = get_tree().get_nodes_in_group("player")[0]

onready var attack_mat = preload("res://materials/Angel_AttackMat.tres")
onready var idle_mat = preload("res://materials/Angel_IdleMat.tres")



func _ready():
	$"3DLabel".text3d = "idle"
	
	#store starting position so we can return later
	start_position = self.global_transform.origin
	$"3DLabel".visible = false
	


func _process(delta):
	
	
	if is_eating == true:
		state = 'eating'
		return
	
	
	if can_see_player():
		state = 'attack'
		$"3DLabel".text3d = state
	else:		
		state = 'idle'
		$"3DLabel".text3d = state
	
	
	if state == 'idle':
		#return to start position
		look_at(start_position, Vector3(0, 1, 0))
		var move_vel = Vector3(0,0, -(MOVE_SPEED) * delta)
		move_vel = move_vel.rotated(Vector3(0,1,0), self.rotation.y)
		move_and_slide(move_vel, Vector3(0,1,0))
		
	elif state == 'attack':
		#face player
		look_at(player.global_transform.origin, Vector3(0, 1, 0))
		
		#check frozen
		
		
		
		if is_frozen == true:
			#dont move
			pass
		else:
			#move foward (at player)
			var move_vel = Vector3(0,0, -MOVE_SPEED * delta)
			move_vel = move_vel.rotated(Vector3(0,1,0), self.rotation.y)
			move_and_slide(move_vel, Vector3(0,1,0))
	
	
	
	
	
	

func toggle_freeze(set_frozen):
	is_frozen = set_frozen
	if is_frozen:
		$Face.material = idle_mat
	else:
		$Face.material = attack_mat



func can_see_player():
	
	
	#shoot a ray from the angel to the player to see if it collides with anything else
	var space_state = get_world().direct_space_state
	
	var result = space_state.intersect_ray(self.get_global_transform().origin, player.get_global_transform().origin)
	if result.size() == 0: return true
	return false

func _on_AttackArea_body_entered(body):
	is_eating = true
	$AudioStreamPlayer3D.play()
	body.death()
	
