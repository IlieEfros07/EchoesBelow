extends CharacterBody2D

const SPEED = 150.0
const ACCELERATION = 1000.0
const DECELERATION = 1400.0
const WOBBLE_AMOUNT = 7.0
const WOBBLE_SPEED = 16.0
const sword_slash_preload = preload("res://Scenes/sword_slash.tscn")

@onready var animation_player: AnimationPlayer = $AnimatedSprite2D/sword/AnimationPlayer

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var can_slash: bool = true
@export var slash_time: float = 0.2
@export var sword_return_time: float = 0.5
@export var weapon_damage: float = 1.0



var main_sword: Node2D
var last_direction = Vector2.DOWN
var wobble_timer = 0.0
var sword_scene = load("res://Scenes/main_sword.tscn")
var is_sword_equipped = false

func _ready():
	pass
	#equip_sword.call_deferred(sword_scene)

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	

	if Input.is_action_pressed("hit") and can_slash:
		animation_player.speed_scale = animation_player.get_animation("sword").length / slash_time
		animation_player.play("sword")
		can_slash = false
	
	
	if direction.length() > 0:
		direction = direction.normalized()
		last_direction = direction
		velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
		wobble_timer += delta * WOBBLE_SPEED
		animated_sprite_2d.rotation_degrees = sin(wobble_timer) * WOBBLE_AMOUNT
	else:
		velocity = velocity.move_toward(Vector2.ZERO, DECELERATION * delta)
		animated_sprite_2d.rotation_degrees = 0
		animated_sprite_2d.play("Idle")
		wobble_timer = 0

	#if is_sword_equipped and main_sword:
		#update_sword_position(delta)
	move_and_slide()


func spawn_slash():
	var sword_slash = sword_slash_preload.instantiate()
	sword_slash.global_position = global_position
	sword_slash.get_node("Sprite2D/AnimationPlayer").speed_scale = sword_slash.get_node("Sprite2D/AnimationPlayer").get_animation("slash").length / slash_time
	sword_slash.get_node("Sprite2D").flip_v = false if get_global_mouse_position().x > global_position.x else true
	sword_slash.weapon_damage = weapon_damage
	get_parent().add_child(sword_slash)
#func equip_sword(sword_scene: PackedScene):
	#if main_sword:
		#main_sword.queue_free()
	#main_sword = sword_scene.instantiate()
	#add_child.call_deferred(main_sword)
	#is_sword_equipped = true
#
#func update_sword_position(delta: float):
	#if not main_sword:
		#return
	#var mouse_pos = get_global_mouse_position()
	#var direction_to_mouse = (mouse_pos - global_position).normalized()
	#var sword_distance = 20.0
	#var target_position = global_position + (direction_to_mouse * sword_distance)
	#main_sword.global_position = main_sword.global_position.lerp(target_position, 15.0 * delta)
	#var angle_to_mouse = direction_to_mouse.angle()
	#main_sword.rotation = lerp_angle(main_sword.rotation, angle_to_mouse, 15.0 * delta)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "sword":
		animation_player.speed_scale = animation_player.get_animation("sword_return").length / slash_time
		animation_player.play("sword_return")
		can_slash = false
	else:
		can_slash = true
		
