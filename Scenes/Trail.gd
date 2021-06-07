extends Node2D

onready var game = get_parent().get_parent().get_parent()
onready var yeti = get_parent().get_parent().get_node("YSort/Yeti")
onready var fade_tween = $FadeTween
var fade_speed : float = 0.3
var velocity = Vector2.ZERO

func _ready():
	fade_tween.interpolate_property(self,"modulate",modulate,Color(1,1,1,0),fade_speed,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	fade_tween.start()

func _process(delta):
	position.x -=  (game.global_speed) * delta

func _on_FadeTween_tween_all_completed():
	queue_free()
