extends Spatial

func _ready():
	pass # Replace with function body.


func _process(delta):
	var a = -self.global_transform.basis.z#flashlight forward vector
	
	for e in get_tree().get_nodes_in_group("angel"):
		var b = (e.global_transform.origin - self.global_transform.origin).normalized() # Vector from flashlight to angel
		
		#print( str(acos(a.dot(b))) + "  " + str(deg2rad(26)) )
		if acos(a.dot(b)) <= deg2rad(26):
			e.call("toggle_freeze", true)
		else:
			e.call("toggle_freeze", false)
