extends Node2D

# Outside nodes
onready var game = get_parent().get_parent().get_parent()
onready var cracks = get_parent().get_parent().get_node("Cracks")

# Nodes
onready var sprite = $PushSkin/IdleSkin/HitSkin/BearSprite
onready var damage_collision = $PushSkin/IdleSkin/HitSkin/DamageArea/DamageCollision
onready var bear_sprite = $PushSkin/IdleSkin/HitSkin/BearSprite

# Players
onready var hit_player = $Players/HitPlayer
onready var push_player = $Players/PushPlayer

# Timers
onready var off_walk_timer = $Timers/OffWalkTimer
onready var walk_timer = $Timers/WalkTimer

# Parameters
var right_direction = true
var walk = true
var local_speed : float = 20
var velocity = Vector2.ZERO
var impact : float = 250

func _ready():
	set_rand_direction()
	set_rand_behaviour()

func _process(delta):
	position.y = clamp(position.y, 10, 180)
	movement(delta)
	if position.x < -200:
		queue_free()

func set_rand_size():
	var rand_size = rand_range(0.8, 1)
	scale = Vector2(rand_size, rand_size)
	local_speed *= rand_size
	impact *= rand_size

func set_rand_direction():
	var rand_direction = round(rand_range(0,1))
	if rand_direction == 0:
		right_direction = true
		set_rand_velocity()
	elif rand_direction == 1:
		right_direction = false
		bear_sprite.flip_h = true
		set_rand_velocity()

func set_rand_velocity():
	if right_direction:
		velocity = Vector2(1, rand_range(-1,1))
	elif !right_direction:
		velocity = Vector2(-1, rand_range(-1,1))

func set_rand_behaviour():
	var rand_behaviour = round(rand_range(0,1))
	if rand_behaviour == 0:
		walk = false
		sprite.play("Idle")
		walk_timer.wait_time = rand_range(0.5,1.5)
		walk_timer.start()
	elif rand_behaviour == 1:
		walk = true
		sprite.play("Walk")
		off_walk_timer.wait_time = rand_range(1,3)
		off_walk_timer.start()

func movement(delta):
	position.x -= game.global_speed * delta
	if walk:
		position += velocity * local_speed * delta

func get_damage():
	damage_collision.set_deferred("disabled", true)
	hit_player.play("Hit")

func _on_OffWalkTimer_timeout():
	walk = false
	push_player.play("Push")
	bear_sprite.play("Idle")
	walk_timer.wait_time = rand_range(0.5,1)
	walk_timer.start()

func _on_WalkTimer_timeout():
	walk = true
	set_rand_velocity()
	push_player.play("Push")
	bear_sprite.play("Walk")
	off_walk_timer.wait_time = rand_range(1,2)
	off_walk_timer.start()

