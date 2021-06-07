extends CPUParticles2D

func _ready():
	emitting = true

func _on_EndTimer_timeout():
	queue_free()
