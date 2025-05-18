extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	$AnimationPlayer.play("zumbi")
