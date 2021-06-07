extends KinematicBody2D

# Prefabs
onready var trail = preload("res://Scenes/Trail.tscn")
onready var snow_trail = preload("res://Scenes/YetiTrail.tscn")

# Outside noes
onready var game = get_parent().get_parent().get_parent()
onready var trails = get_parent().get_parent().get_node("Trails")
onready var snow_trails = get_parent().get_parent().get_node("SnowTrails")
onready var camera = get_parent().get_parent().get_parent().get_node("Camera")

# Colors
var damage_color = Color(3,0,0,1)
var trick_color = Color(3,3,3,1)

# Nodes
onready var jump_skin = $JumpSkin
onready var angle_skin = $JumpSkin/IdleSkin/DamageSkin/AngleSkin
onready var damage_skin = $JumpSkin/IdleSkin/DamageSkin
onready var trick_skin = $JumpSkin/IdleSkin/DamageSkin/AngleSkin/TricksFix/Tricks
onready var trick_fix = $JumpSkin/IdleSkin/DamageSkin/AngleSkin/TricksFix
onready var sprite = $JumpSkin/IdleSkin/DamageSkin/AngleSkin/TricksFix/Tricks/YetiSprite
onready var between_sprite = $JumpSkin/IdleSkin/DamageSkin/AngleSkin/TricksFix/Tricks/BetweenYetiSprite

# Areas
onready var damage_area = $JumpSkin/IdleSkin/DamageSkin/AngleSkin/TricksFix/Tricks/DamageArea

# Players
onready var damage_player = $Players/DamagePlayer
onready var trick_player = $Players/TrickPlayer
onready var perform_trick_player = $Players/PerformTrickPlayer

# Timers
onready var between_frame_timer = $Timers/BetweenFrameTimer

# Parameters
var acceleration = 400

var local_speed : float = 100
var velocity = Vector2.ZERO

# Jump
var on_floor = true
var jump_velocity = Vector2.ZERO
var jump_strength = 200
var gravity = 300

# Tricks
enum {IDLE, BACK, TURN, ROTATE, ANGLE, UPSIDE}
var trick = IDLE
var trick_action = false
var trick_completed = false
var right_click = 0
var left_click = 0
var up_click = 0
var down_click = 0

######################################################
### CORE CYCLE ###
##################

func _physics_process(delta):
	position.y = clamp(position.y, 10, 180)
	global_position.y = clamp(global_position.y, 0, 180)
	global_position.x = clamp(global_position.x, 0, 320)
	jump_skin.position.y = clamp(jump_skin.position.y, -200, 0)
	
	tricks()
	movement(delta)
	jump(delta)
	apply_gravity(delta)
	color_correct()
	spawn_snow_trail()

#######################################################
### MOVEMENT ###
################

func movement(delta):
	var axis = get_input_axis()
	if axis == Vector2.ZERO:
		apply_friction(acceleration * delta)
	else:
		apply_movement(axis * acceleration * delta)
	velocity = move_and_slide(velocity)

	if axis.x > 0 and axis.y < 0:
		angle_skin.rotation_degrees = lerp(angle_skin.rotation_degrees, -15, 0.05)
	elif axis.x > 0 and axis.y > 0:
		angle_skin.rotation_degrees = lerp(angle_skin.rotation_degrees, 15, 0.05)
	elif axis.x > 0 and axis.y == 0:
		angle_skin.rotation_degrees = lerp(angle_skin.rotation_degrees, 10, 0.05)
		
	elif axis.x < 0 and axis.y > 0:
		angle_skin.rotation_degrees = lerp(angle_skin.rotation_degrees, 15, 0.05)
	elif axis.x < 0 and axis.y < 0:
		angle_skin.rotation_degrees = lerp(angle_skin.rotation_degrees, -15, 0.05)
	elif axis.x < 0 and axis.y == 0:
		angle_skin.rotation_degrees = lerp(angle_skin.rotation_degrees, -10, 0.05)
	
	elif axis.x == 0 and axis.y > 0:
		angle_skin.rotation_degrees = lerp(angle_skin.rotation_degrees, 10, 0.05)
	elif axis.x == 0 and axis.y < 0:
		angle_skin.rotation_degrees = lerp(angle_skin.rotation_degrees, -10, 0.05)
	
	if axis.x != 0 and axis.y == 0:
		angle_skin.scale.x = lerp(angle_skin.scale.x, 0.9, 0.05)
	elif axis.x != 0 and axis.y != 0:
		angle_skin.scale.x = lerp(angle_skin.scale.x, 0.8, 0.05)
		
	if axis.y != 0 and axis.x == 0:
		angle_skin.scale.y = lerp(angle_skin.scale.y, 1.1, 0.05)
	elif axis.y != 0 and axis.x != 0:
		angle_skin.scale.y = lerp(angle_skin.scale.y, 1.2, 0.05)
	
	elif axis == Vector2.ZERO:
		angle_skin.rotation_degrees = lerp(angle_skin.rotation_degrees, 0, 0.05)
		angle_skin.scale = lerp(angle_skin.scale, Vector2(1,1), 0.05)

func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return axis.normalized()

func jump(delta):
	if on_floor and Input.is_action_pressed("jump"):
		on_floor = false
		damage_area.get_node("DamageCollision").set_deferred("disabled", true)
		jump_velocity.y -= jump_strength
	
	if on_floor:
		jump_velocity = Vector2.ZERO
		
	jump_skin.position += jump_velocity * delta
	
	if jump_skin.position.y >= 0 and !on_floor:
		camera.land_shake()
		on_floor = true
		damage_area.get_node("DamageCollision").set_deferred("disabled", false)
		if trick_action and !trick_completed:
			trick_action = false
			trick_completed = true
			trick = IDLE
			get_damage()
	
	if abs(jump_velocity.y) != 0:
		jump_skin.scale = lerp(jump_skin.scale, Vector2(0.7,1.3), 0.1)
	elif abs(jump_velocity.y) == 0:
		jump_skin.scale = lerp(jump_skin.scale, Vector2(1,1), 0.1)

################################################
### FORCES ###
##############

func apply_gravity(delta):
	if !on_floor:
		jump_velocity.y += gravity * delta

func apply_friction(amount):
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO

func apply_movement(acceleration_amount):
	velocity += acceleration_amount
	if velocity.length() >= local_speed:
		velocity = velocity.normalized() * local_speed

##############################################################
### TRICKS ###
##############

func tricks():
	if !on_floor and trick == IDLE and !trick_action and (jump_velocity.y <= 0 or jump_skin.position.y < 16):
		if up_click >= 1 and Input.is_action_just_pressed("move_up"):
			trick = ANGLE
			trick_action = true
			trick_completed = false
			perform_trick_player.play("Push")
			set_between_frame()
			sprite.play("Trick1")
			trick_player.play("Angle")
		elif left_click >= 1 and Input.is_action_just_pressed("move_left"):
			trick = BACK
			trick_action = true
			trick_completed = false
			perform_trick_player.play("Push")
			set_between_frame()
			sprite.play("Trick2")
			trick_player.play("Back")
		elif left_click >= 1 and Input.is_action_just_pressed("move_right"):
			trick = ROTATE
			trick_action = true
			trick_completed = false
			perform_trick_player.play("Push")
			set_between_frame()
			sprite.play("Trick3")
			trick_player.play("Rotate")
		elif right_click >= 1 and Input.is_action_just_pressed("move_right"):
			trick = TURN
			trick_action = true
			trick_completed = false
			perform_trick_player.play("Push")
			set_between_frame()
			sprite.play("Trick4")
			trick_player.play("Turn")
		elif down_click >= 1 and Input.is_action_just_pressed("move_down"):
			trick = UPSIDE
			trick_action = true
			trick_completed = false
			perform_trick_player.play("Push")
			set_between_frame()
			sprite.play("Trick5")
			trick_player.play("Upside")
	if on_floor and trick == IDLE:
		trick_action = false
	if !on_floor:
		if Input.is_action_just_pressed("move_left"):
			left_click += 1
		if Input.is_action_just_pressed("move_right"):
			right_click += 1
		if Input.is_action_just_pressed("move_up"):
			up_click += 1
		if Input.is_action_just_pressed("move_down"):
			down_click += 1
	elif on_floor:
		left_click = 0
		right_click = 0
		up_click = 0
		down_click = 0

func set_between_frame():
	between_sprite.animation = sprite.animation
	between_sprite.stop()
	between_sprite.frame = sprite.frame
	between_sprite.visible = true
	between_frame_timer.start()

func trick_complete():
	trick_completed = true
	perform_trick_player.play("Push")
	set_between_frame()
	sprite.play("Idle")

func _on_TrickPlayer_animation_finished(_anim_name):
	trick = IDLE

func _on_BetweenFrameTimer_timeout():
	between_sprite.visible = false

##############
### DAMAGE ###
###########################################################

func _on_DamageArea_area_entered(area):
	if area.is_in_group("obstacles"):
		var obstacle = area.get_parent().get_parent().get_parent().get_parent()
		get_damage()
		obstacle.get_damage()
	elif area.is_in_group("bears"):
		var bear = area.get_parent().get_parent().get_parent().get_parent()
		var new_impact = (bear.position - position).normalized() * bear.impact
		get_bear_damage(new_impact)
		bear.get_damage()
		
func get_damage():
	damage_player.play("Damage")
	camera.small_shake()
	damage_skin.modulate = damage_color

func get_bear_damage(new_impact):
	damage_player.play("Damage")
	camera.small_shake()
	damage_skin.modulate = damage_color
	velocity -= new_impact
	if velocity.x < -200:
		velocity.x = -200
	elif velocity.x > 200:
		velocity.x = 200
	if velocity.y < -200:
		velocity.y = -200
	elif velocity.y > 200:
		velocity.y = 200 

func trail_effect():
	var new_trail = trail.instance()
	var new_alpha 
	var movement_alpha = (abs(velocity.x) / local_speed) / 1.5
	var jump_alpha = (abs(jump_velocity.y) / jump_strength) / 1.5
	if movement_alpha >= jump_alpha:
		new_alpha = movement_alpha
	elif jump_alpha >= movement_alpha:
		new_alpha = jump_alpha
	
	new_trail.modulate.a = new_alpha
	new_trail.get_node("Skin").scale = sprite.global_scale
	new_trail.get_node("Skin").rotation_degrees = sprite.global_rotation_degrees - game.slope 
	new_trail.get_node("Skin/YetiSprite").frame = sprite.frame
	new_trail.get_node("Skin/YetiSprite").stop()
	new_trail.position = position + jump_skin.position + trick_fix.position
	trails.add_child(new_trail)
	new_trail.owner = trails

func _on_TrailTimer_timeout():
	if (velocity.x > 0 and velocity.length() > 0) or jump_velocity.length() > 0:
		trail_effect()
	
func color_correct():
	damage_skin.modulate = lerp(damage_skin.modulate, Color(1,1,1,1), 0.1)
	trick_skin.modulate = lerp(trick_skin.modulate, Color(1,1,1,1), 0.1)

func spawn_snow_trail():
	if on_floor:
		var new_snow_trail = snow_trail.instance()
		new_snow_trail.position = position + Vector2(0,-1)
		new_snow_trail.rotation_degrees = sprite.global_rotation_degrees - game.slope - trick_skin.rotation_degrees
		snow_trails.add_child(new_snow_trail)
