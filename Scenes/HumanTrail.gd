extends Sprite

onready var game = get_parent().get_parent().get_parent()

var velocity = Vector2(-1,0)

func _process(delta):
	movement(delta)
	if position.x < -200:
		queue_free()

func movement(delta):
	position.x -= game.global_speed * delta
