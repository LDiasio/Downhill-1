extends Node2D

# Outside nodes
onready var game = get_parent().get_parent().get_parent()
onready var yeti = get_parent().get_parent().get_node("YSort/Yeti")

# Nodes
onready var skin = $Skin

func _process(_delta):
	position = yeti.position
	var percent = abs(yeti.jump_skin.position.y / 100)
	var alpha_percent = (1 - percent) - 0.2
	skin.modulate.a = alpha_percent
	skin.scale = Vector2(percent + 0.35, percent)
	skin.rotation_degrees = yeti.sprite.global_rotation_degrees - game.slope
