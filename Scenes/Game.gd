extends Node

# Prefabs
onready var obstacle = preload("res://Scenes/Obstacle.tscn")
onready var flag = preload("res://Scenes/Flag.tscn")
onready var bear = preload("res://Scenes/Bear.tscn")

# Nodes
onready var mountain = $Bodies
onready var bodies = $Bodies/YSort
onready var flags = $Bodies/Flags

# Timers
onready var obstacles_timer = $Timers/SpawnObstacleTimer

# Parameters
var global_speed = 100
var slope = 10

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	randomize()
	mountain.rotation_degrees = slope
	
#func _process(delta):
#	obstacles_timer.wait_time = 1 * (global_speed / 100)

func _on_SpawnObstacleTimer_timeout():
	var kind_of_obstacle = round(rand_range(0,4))
	if kind_of_obstacle < 4:
		spawn_obstacle()
	elif kind_of_obstacle >= 2:
		spawn_bear()
	increase_speed()

func spawn_obstacle():
	var new_obstacle = obstacle.instance()
	new_obstacle.position.x = 384
	new_obstacle.position.y = rand_range(32, 128)
	bodies.add_child(new_obstacle)
	new_obstacle.owner = bodies
	
	var new_flag = flag.instance()
	new_flag.position.x = 384
	new_flag.position.y = 4
	flags.add_child(new_flag)
	new_flag.owner = flags

func spawn_bear():
	var new_bear = bear.instance()
	new_bear.position.x = 384
	new_bear.position.y = rand_range(32, 100)
	bodies.add_child(new_bear)
	new_bear.owner = bodies

func increase_speed():
	if global_speed < 250:
		global_speed *= 1.01
		obstacles_timer.wait_time *= 0.99
		
