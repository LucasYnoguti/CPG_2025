extends Node2D
@export var bola_scene: PackedScene

func _on_timer_1_timeout() -> void:
	var bola = bola_scene.instantiate()
	var bola_spawn_location  = $bola1/PathFollow2D
	print("Bola NOva")
	bola_spawn_location.progress_ratio = randf()
	bola.position = bola_spawn_location.position
	print(bola.position)
	add_child(bola)


func _on_enabler_1_screen_exited() -> void:
	$Timer1.stop()


func _on_enabler_1_screen_entered() -> void:
	$Timer1.start()




func _on_enabler_2_screen_entered() -> void:
	$Timer2.start()


func _on_enabler_2_screen_exited() -> void:
	$Timer2.stop()


func _on_timer_2_timeout() -> void:
	var bola = bola_scene.instantiate()
	var bola_spawn_location  = $bola2/PathFollow2D
	bola_spawn_location.progress_ratio = randf()
	bola.position = bola_spawn_location.position
	print(bola.position)
	add_child(bola)
	



func _on_timer_3_timeout() -> void:
	var bola = bola_scene.instantiate()
	var bola_spawn_location  = $bola3/PathFollow2D
	bola_spawn_location.progress_ratio = randf()
	bola.position = bola_spawn_location.position
	print(bola.position)
	add_child(bola)


func _on_enabler_3_screen_entered() -> void:
	$Timer3.start()


func _on_enabler_3_screen_exited() -> void:
	$Timer3.stop()

var secs: int = 0
func _on_timer_text_timeout() -> void:
	secs += 1
	print(secs)
	if secs == 2:
		$Control/AnimationPlayer.play("textovelho")
	if secs == 10:
		$Control/Label.queue_free()
		$Control/AnimationPlayer.play("textonovo1")
	if secs == 15:
		$Control/Label2.queue_free()
		$TimerText.stop()
	
	
var segundos: int = 0
func _on_timer_pocao_timeout() -> void:
	segundos +=1
	if segundos == 1:
		$Control/AnimationPlayer.play("voceconseguiu")
		
	if segundos == 5:
		$TileMap/mae.queue_free()
		$TileMap/zumbi.visible = true
		$Control/Label4.queue_free()
		
	if segundos == 6:
		$Control/AnimationPlayer.play("textomulherdoente")
	if segundos == 13:
		$Control/Label5.queue_free()
		$TimerPocao.stop()
	
		
	
var first_time: bool = true

func _on_pocao_area_entered(area: Area2D) -> void:
	if first_time:
		$TileMap/plat.queue_free()
		$TimerPocao.start()
		first_time = false
	else:
		$Control/Label7.visible = true
	
