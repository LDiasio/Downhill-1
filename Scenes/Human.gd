extends Node2D

# Outside nodes
onready var game = get_parent().get_parent().get_parent()
onready var snow_trails = get_parent().get_parent().get_node("SnowTrails")
onready var yeti = get_parent().get_node("Yeti")

# Prefabs
onready var snow_trail = preload("res://Scenes/HumanTrail.tscn")

# Nodes
onready var sprite = $Skin1/Skin2/Skin3/HumanSprite

# Parameters
var kind_of_human = 0
var eaten = false
var local_speed = 25
var velocity = Vector2(1,0)
var trail_alpha = 0

func _ready():
	set_random_skin()

func _process(delta):
	movement(delta)
	if position.x < -200:
		queue_free()
	spawn_snow_trail()

func movement(delta):
	position.x -= game.global_speed * delta
	position += velocity.normalized() * local_speed * delta

func set_random_skin():
	var rand_skin = round(rand_range(1,16))
	kind_of_human = rand_skin
	sprite.play(str(rand_skin))

func spawn_snow_trail():
	trail_alpha = lerp(trail_alpha, 1, 0.01)
	var new_snow_trail = snow_trail.instance()
	new_snow_trail.modulate.a = trail_alpha
	new_snow_trail.position = position + Vector2(0,-1)
	new_snow_trail.rotation_degrees = sprite.global_rotation_degrees - game.slope
	snow_trails.add_child(new_snow_trail)

func eat():
	eaten = true
	yeti.eat_humans(kind_of_human, global_position)
	queue_free()

