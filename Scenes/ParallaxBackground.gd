extends ParallaxBackground

func _physics_process(delta):
	var MOUNTAIN_SPEED = get_node("/root/Game").global_speed
	$ParallaxLayer2.motion_offset.x -= (MOUNTAIN_SPEED /1.2 - 70) * delta
	$ParallaxLayer3.motion_offset.x -= (MOUNTAIN_SPEED /1.2 - 60) * delta
	$ParallaxLayer4.motion_offset.x -= (MOUNTAIN_SPEED /1.2 - 40) * delta
