extends Spatial

var text3d = 'hello' setget set_text, get_text



func set_text(v):
	$Viewport/Control/Label.text = v

func get_text():
	return $Viewport/Control/Label.text
