extends Node2D

var weapon_damage: float = 1.0
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer

func _ready() -> void:
	look_at(get_global_mouse_position())
	animation_player.play("slash")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "slash":
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemie"):
		body.take_damage(weapon_damage)
