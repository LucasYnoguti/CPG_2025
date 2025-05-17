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
		"andar_esquerda", "andar_direita", "escalar_cima", "")
		
func _physics_process(delta: float) -> void:
	movimentacao()
	velocity.x = direcao.x * velocidade_movimento
	
	if escalando:
		velocity.y = direcao.y * velocidade_movimento # Gravidade nao é aplicada se esta escalando
	else:
		velocity.y += gravidade * delta # Gravidade é aplicada se nao esta escalando
		if is_on_floor() and Input.is_action_just_pressed("escalar_cima"): # Pulo
			velocity.y = forca_do_pulo
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	escalando = true
	pass # Replace with function body.


func _on_area_2d_area_exited(area: Area2D) -> void:
	escalando = false
	pass # Replace with function body.
