extends Node2D

onready var sprite = $Skin/CrackSprite
onready var game = get_parent().get_parent().get_parent()
var velocity = Vector2(-1,0)

enum {ROCK, TREE, SNOWMAN}
var kind 

func _ready():
	if kind == ROCK:
		sprite.play("Rock")
	elif kind == TREE:
		sprite.play("Tree")
	elif kind == SNOWMAN:
		sprite.play("Snowman")

func _process(delta):
	movement(delta)
	if position.x < -200:
		queue_free()

func movement(delta):
	position.x -= game.global_speed * delta


