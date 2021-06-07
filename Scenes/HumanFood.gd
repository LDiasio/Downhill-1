extends Node2D

onready var yeti = get_parent().get_parent()

func _process(_delta):
	position = lerp(position, Vector2(0,0), 0.1)
	
func swallow():
	yeti.swallow()
	
func _on_EatPlayer_animation_finished(_anim_name):
	queue_free()
