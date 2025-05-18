extends Area2D

func _physics_process(delta: float) -> void:
	$AnimationPlayer.play("pocao")
