extends CharacterBody2D

const SPEED = 150.0
const ACCELERATION = 1000.0
const DECELERATION = 1400.0
const WOBBLE_AMOUNT = 7.0
const WOBBLE_SPEED = 16.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var main_sword: Node2D
var last_direction = Vector2.DOWN
var wobble_timer = 0.0
var sword_scene = load("res://Scenes/main_sword.tscn")
var is_sword_equipped = false


func _ready():

	equip_sword.call_deferred(sword_scene)

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	
	
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

	if is_sword_equipped and main_sword:
		update_sword_position(delta)

	move_and_slide()
	
func equip_sword(sword_scene: PackedScene):
	if main_sword:
		main_sword.queue_free()
	
	main_sword = sword_scene.instantiate()

	add_child.call_deferred(main_sword)
	
	is_sword_equipped = true

func update_sword_position(delta: float):
	if not main_sword:
		return

	var follow_distance = 20.0 
	var bounce_height = 3.0
	var bounce_speed = 8.0
	

	var base_offset = Vector2.ZERO
	
	var horizontal_direction = last_direction.x
	if horizontal_direction == 0:
		horizontal_direction = 1 
	
	if horizontal_direction > 0:
		base_offset = Vector2(follow_distance, 0)
		main_sword.rotation_degrees = 0
	else:
		base_offset = Vector2(-follow_distance, 0)
		main_sword.rotation_degrees = 0
	
	var bounce_offset = Vector2(0, sin(Time.get_ticks_msec() * 0.001 * bounce_speed) * bounce_height)

	var target_position = global_position + base_offset + bounce_offset
	main_sword.global_position = main_sword.global_position.lerp(target_position, 10.0 * delta)

func start_attack():
	if main_sword:
		pass

func end_attack():
	if main_sword:
		pass
