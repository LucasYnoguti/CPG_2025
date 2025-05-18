extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
	$AnimationPlayer.play("bola_neve")
	
	




func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "zona_morte":
		queue_free()
		
		
