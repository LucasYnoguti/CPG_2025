extends CharacterBody2D

@export var velocidade_movimento: float = 10
@export var gravidade = 500
@export var forca_pulo_min = 200
@export var forca_pulo_max = 800
@export var velocidade_carga_pulo = 500

var escalando = false
var pulando = false
var direcao = Vector2.ZERO
var olhando_direita = true

var carregando_pulo = false
var forca_pulo_atual = 0
var aumentando_pulo = true

func movimentacao():
	if escalando:
		direcao = Input.get_vector("andar_esquerda", "andar_direita", "escalar_cima", "escalar_baixo")
	elif not escalando and not pulando:
		direcao = Input.get_vector("andar_esquerda", "andar_direita", "escalar_cima", "")

	# Atualiza direção do olhar
	if direcao.x >= 0:
		olhando_direita = true
	elif direcao.x < 0:
		olhando_direita = false

func _physics_process(delta: float) -> void:
	movimentacao()

	# Movimento horizontal só se não estiver pulando nem carregando
	if escalando:
		velocity.x = direcao.x * velocidade_movimento
	elif not pulando and not carregando_pulo:
		velocity.x = direcao.x * velocidade_movimento

	# Escalada ativa
	if escalando:
		velocity.y = direcao.y * velocidade_movimento
	else:
		velocity.y += gravidade * delta

		# Início do carregamento
		if is_on_floor() and Input.is_action_just_pressed("escalar_cima"):
			carregando_pulo = true
			forca_pulo_atual = forca_pulo_min
			aumentando_pulo = true
			pulando = true
			velocity = Vector2.ZERO

		# Durante o carregamento
		if carregando_pulo:
			_carregar_pulo(delta)

		# Libera o pulo
		if Input.is_action_just_released("escalar_cima") and carregando_pulo:
			carregando_pulo = false
			var direcao_horizontal
			if olhando_direita:
				direcao_horizontal = 1
			else:
				direcao_horizontal = -1
			velocity.x = direcao_horizontal * forca_pulo_atual * 0.6
			velocity.y = -forca_pulo_atual

	# Se tocou o chão e não está carregando, pode se mover novamente
	if is_on_floor() and not carregando_pulo:
		pulando = false

	move_and_slide()

func _carregar_pulo(delta: float):
	var passo = velocidade_carga_pulo * delta
	if aumentando_pulo:
		print(forca_pulo_atual)
		forca_pulo_atual += passo
		if forca_pulo_atual >= forca_pulo_max:
			forca_pulo_atual = forca_pulo_max
			aumentando_pulo = false
	else:
		print(forca_pulo_atual)
		forca_pulo_atual -= passo
		if forca_pulo_atual <= forca_pulo_min:
			forca_pulo_atual = forca_pulo_min
			aumentando_pulo = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	escalando = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	escalando = false
