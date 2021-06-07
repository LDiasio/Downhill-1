extends Node2D

onready var game = get_parent().get_parent().get_parent()

func _process(delta):
	movement(delta)
	if position.x < -200:
		queue_free()

func movement(delta):
	position.x -= game.global_speed * delta
