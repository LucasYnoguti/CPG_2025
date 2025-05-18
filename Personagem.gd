extends CharacterBody2D

@export var velocidade_movimento: float = 150
@export var gravidade = 500
@export var forca_do_pulo = -100 
var timer = false

var esquerda: bool = false
var escalando = false
var escalando_aux = false
var pode_escalar = true
var pulando = false # Impede movimentação no ar
var direcao = Vector2(0, 0)
var ultima_direcao_x = 0
var timer_rodando = false

func movimentacao():
	if escalando and pode_escalar:
		direcao = Input.get_vector(
			"andar_esquerda", "andar_direita", "escalar_cima", "escalar_baixo")
	elif !escalando and !pulando and is_on_floor():
		direcao = Input.get_vector(
			"andar_esquerda", "andar_direita", "nada", "nada")
	
func animacao():
			
	if is_on_floor() and esquerda and !escalando and velocity.x == 0 and $Animacao_seta.current_animation != "parado_esquerda" and !pulando:
		$Animacao_player.play("parado_esquerda")
	elif is_on_floor() and !esquerda and !escalando and velocity.x == 0 and $Animacao_seta.current_animation != "parado_direita" and !pulando:
		$Animacao_player.play("parado_direita")
	
	if escalando:
		$Animacao_player.play("escalando")
	elif direcao.x == 1 and is_on_floor() and !pulando:
		$Animacao_player.play("andando_direita")
	elif direcao.x == -1 and is_on_floor() and !pulando:
		$Animacao_player.play("andando_esquerda")
	if !is_on_floor() and !escalando and velocity.x < 0:
		$Animacao_player.play("pulando_esquerda")
	if !is_on_floor() and !escalando and velocity.x > 0:
		$Animacao_player.play("pulando_direita")
func _physics_process(delta: float) -> void:
	movimentacao()
	
	if direcao.x == -1:
		esquerda = true
	elif direcao.x == 1:
		esquerda = false
	
	if is_on_floor():
		pode_escalar = true
		timer_rodando = false
		$Timer_escalada.stop()
	if is_on_floor() and !escalando:
		$Barra.visible = false
		$Timer_escalada.stop()
	#print(ultima_direcao_x)                            
	if is_on_floor() and !pulando and !escalando:
		velocity.x = direcao.x * velocidade_movimento
	
	if escalando and pode_escalar:
		$Animacao_barra.play("barra")
		if !escalando_aux:
			velocity.x = 0
			escalando_aux = true
		velocity.y = direcao.y * velocidade_movimento
		velocity.x = direcao.x * velocidade_movimento
	else:
		velocity.y += gravidade * delta

	animacao()

	if Input.is_action_pressed("pular") and !escalando and is_on_floor():
		pulando = true
		velocity.x = 0
		# Ajusta força do pulo automaticamente invertendo sentido quando chegar nos limites
		if timer and forca_do_pulo > -400: # 2,5 segundos 
			forca_do_pulo += -2
		elif !timer and forca_do_pulo < -100:
			forca_do_pulo += 2
		else:
			timer = !timer  # Inverte o sentido quando chegar no limite
		if Input.is_action_pressed("andar_esquerda"):
			ultima_direcao_x = 1  # esquerda
		elif Input.is_action_pressed("andar_direita"):
			ultima_direcao_x = -1  # direita
		elif Input.is_action_pressed("escalar_cima"):
			ultima_direcao_x = 0  # NAO É AQUI O PROBLEMA COM O TIMER

		if ultima_direcao_x == 1 and $Animacao_seta.current_animation != "seta_diagonal_esquerda":
			$Seta_diagonal_direita.visible = false
			$Seta_cima.visible = false
			forca_do_pulo = -100
			timer = false
			$Animacao_seta.play("seta_diagonal_esquerda")
			$Animacao_player.play("agachado_esquerda")
		elif ultima_direcao_x == -1 and $Animacao_seta.current_animation != "seta_diagonal_direita":
			# ESSE IF A ULTIMA DIRECAO É -1 MAS ELA QUE FAZ IR PARA DIREITA, JA QUE ELA VAI PRA
			# DIREITA. A ANIMACAO DE SETA DA DIREITA NAO PODE ESTAR ATIVA, SE NAO VAI FICAR CHAMANDO
			# A ANIMACAO EM LOOP
			$Seta_diagonal_esquerda.visible = false
			$Seta_cima.visible = false
			forca_do_pulo = -100
			timer = false
			$Animacao_seta.play("seta_diagonal_direita")
			$Animacao_player.play("agachado_direita")
		elif ultima_direcao_x == 0 and $Animacao_seta.current_animation != "seta_cima":
			$Seta_diagonal_esquerda.visible = false
			$Seta_diagonal_direita.visible = false
			forca_do_pulo = -100
			timer = false
			$Animacao_seta.play("seta_cima")
		
	if Input.is_action_just_released("pular") and is_on_floor() and pulando and !escalando:
		$Animacao_seta.play("RESET")
		$pulo.play()
		velocity.y = forca_do_pulo
		velocity.x = forca_do_pulo * ultima_direcao_x
		forca_do_pulo = -100 
		pulando = false
		ultima_direcao_x = 0

	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	$Barra.visible = true
	$Animacao_barra.stop()
	if !timer_rodando and area.name == "escalada":
		$Timer_escalada.start(6)
		$Animacao_barra.play("barra")
		timer_rodando = true
		escalando = true
		pode_escalar = true
	print(area.name)
	if area.name == "bola_de_neve":
		$hit.play()
	if area.name == "pocao":
		$TimerRestart.start()
		
	
func _on_area_2d_area_exited(area: Area2D) -> void:
	pode_escalar = false
	escalando = false
	escalando_aux = false



func _on_timer_escalada_timeout() -> void:
	pode_escalar = false
	$Barra.visible = false
	timer_rodando = false

var seg:int = 0
func _on_timer_restart_timeout() -> void:
	seg+=1
	if seg == 5:
		position = Vector2(252,1056)
		$TimerRestart.stop()
	
