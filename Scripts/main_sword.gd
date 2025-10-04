extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#
#func play_slash():
	#if animation_player.has_animation("slash"):
		#animation_player.play("slash")
		#if animation_player.has_animation("return"):
			#animation_player.queue("return")
