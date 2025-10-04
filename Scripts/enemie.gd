extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var health = 3

func take_damage(weapon_damage: float):
	modulate = Color.RED
	health-=weapon_damage


#func _physics_process(delta: float) -> void:
#
	#move_and_slide()
