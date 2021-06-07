extends ParallaxLayer

export(float) var MOUNTAIN_SPEED = -15

func _physics_process(delta) -> void:
		self.motion_offset.x += MOUNTAIN_SPEED * delta

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
