extends Control

var scroll_speed = 5

func _ready():
	$Sounds/Music.play()

func _physics_process(delta):
	$ParallaxBackground/ParallaxLayer5.motion_offset.x -= (scroll_speed + 1) * delta
	$ParallaxBackground/ParallaxLayer4.motion_offset.x -= (scroll_speed + 2) * delta
	$ParallaxBackground/ParallaxLayer3.motion_offset.x -= (scroll_speed + 3) * delta
	$ParallaxBackground/ParallaxLayer2.motion_offset.x -= (scroll_speed + 4) * delta

func _on_TextureButton_pressed():
	print("Click!")
	$Sounds/Button.play()
	$Timer.start()
#	var next_scene = preload("res://Scenes/Game.tcsn")  

func _on_Timer_timeout():
	pass
