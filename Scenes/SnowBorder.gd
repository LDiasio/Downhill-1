extends ParallaxBackground

func _physics_process(delta):
	var MOUNTAIN_SPEED = get_node("/root/Game").global_speed
	$ParallaxLayer5.motion_offset.x -= (MOUNTAIN_SPEED /1.3) * delta
