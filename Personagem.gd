extends CharacterBody2D

@export var velocidade_movimento: float = 10
@export var gravidade = 500
@export var forca_do_pulo = -300 



var escalando = false
var pulando = false # Vai funcionar para ele nao poder se movimentar durante o pulo
var direcao = Vector2(0, 0)

func movimentacao():
	if escalando: # Movimentacao eixo y habilitado
		direcao = Input.get_vector(
		"andar_esquerda", "andar_direita", "escalar_cima", "escalar_baixo")
	elif escalando == false and pulando == false: # Movimentacao com eixo y "desabilitado"
		direcao = Input.get_vector(
		"andar_esquerda", "andar_direita", "", "")
	
func animacao():
	if escalando:
		$AnimationPlayer.play("escalando")
	if direcao.x == 1 and escalando == false and is_on_floor():
		$AnimationPlayer.play("andando_direita")
	if direcao.x == -1 and escalando == false and is_on_floor():
		$AnimationPlayer.play("andando_esquerda")

func _physics_process(delta: float) -> void:
	movimentacao()
	velocity.x = direcao.x * velocidade_movimento
	
	if escalando:
		velocity.y = direcao.y * velocidade_movimento # Gravidade nao é aplicada se esta escalando
	else:
		velocity.y += gravidade * delta # Gravidade é aplicada se nao esta escalando
	
	animacao()
	if Input.is_action_pressed("pular"):
		pulando = true
		print("pulando")
	if Input.is_action_just_released("pular") and is_on_floor():
		velocity.y += forca_do_pulo
		pulando = false
		
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	escalando = true
	pass # Replace with function body.


func _on_area_2d_area_exited(area: Area2D) -> void:
	escalando = false
	pass # Replace with function body.
