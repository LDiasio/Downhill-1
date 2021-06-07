extends Node2D

# Outside nodes
onready var game = get_parent().get_parent().get_parent()
onready var cracks = get_parent().get_parent().get_node("Cracks")

# Nodes
onready var sprite = $Skin1/Skin2/Skin3/ObstacleSprite
onready var damage_collision = $Skin1/Skin2/Skin3/DamageArea/DamageCollision
onready var skin1 = $Skin1

# Particles
onready var rock_particles = $Particles/RockParticles
onready var tree_particles = $Particles/TreeParticles
onready var snow_particles = $Particles/SnowParticles

# Prefabs
onready var crack = preload("res://Scenes/Crack.tscn")

enum {ROCK, TREE, SNOWMAN}
var kind

func _ready():
	set_random_obstacle()

func _process(delta):
	movement(delta)
	if position.x < -200:
		queue_free()

func movement(delta):
	position.x -= game.global_speed * delta

func set_random_obstacle():
	var rand_obstacle = round(rand_range(0,2))
	if rand_obstacle == 0:
		kind = ROCK
		sprite.position = Vector2(0, -7)
		sprite.play("Rock")
	elif rand_obstacle == 1:
		kind = TREE
		sprite.position = Vector2(0, -7)
		sprite.play("Tree")
	elif rand_obstacle == 2:
		kind = SNOWMAN
		sprite.position = Vector2(0, -13)
		sprite.play("Snowman")

func get_damage():
	damage_collision.set_deferred("disabled", true)
	skin1.visible = false
	if kind == ROCK:
		rock_particles.emitting = true
	elif kind == TREE:
		tree_particles.emitting = true
	elif kind == SNOWMAN:
		snow_particles.emitting = true
	var new_crack = crack.instance()
	new_crack.get_node("Skin/CrackSprite").play(sprite.animation)
	new_crack.get_node("Skin/CrackSprite").position = sprite.position
	new_crack.position = position
	cracks.add_child(new_crack)
	new_crack.owner = cracks
