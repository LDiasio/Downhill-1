extends Node2D

onready var small_shake_player = $Players/SmallShakePlayer
onready var land_shake_player = $Players/LandShakePlayer

func small_shake():
	small_shake_player.stop()
	small_shake_player.play("SmallShake")

func land_shake():
	land_shake_player.stop()
	land_shake_player.play("LandShake")
