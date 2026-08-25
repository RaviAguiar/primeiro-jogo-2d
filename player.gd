extends Area2D
signal hit

@export var speed = 400
var screen_size
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#função de pegar e setar o tamanho da tela, vai ser útil
	#pro personagem não sair da tela usando a função clamp()
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#to com preguiça de explicar detalhadamente mas esse :float e -> void
#server resumidamente pro programa já prever o tipo de valor de delta
#e se a função vai ou não ter return, isso ajuda em debug
#e é um recurso de otimização, então recomendo usar caso for pertinente
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	#isso faz a var velocity ser (0,0) (literalmente um vetor com x e y)
	if  Input.is_action_pressed('move_up'):
		velocity.y -= 1
	if  Input.is_action_pressed('move_right'):
		velocity.x += 1
	if Input.is_action_pressed('move_down'):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		#o $ no gd.script é tipo um short pra função get_node()
		#e nesse caso ela funciona pq o AnimatedSprite2D é filho do player,
		#fazendo o código encontrar o node q eu to chamando pra executar a animação
		#anyways é a mesma coisa que get_node('AnimatedSprite2D').play()
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	#eu ainda não entendi 100% a função clamp mas pelo que vi é bem de boa de entender,
	#nesse caso aqui a gente tá usando ela pro player não passar pra fora da janela do jogo
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.y != 0:
		$AnimatedSprite2D.animation = 'up'
		$AnimatedSprite2D.flip_v = velocity.y > 0
	elif velocity.x != 0:
		$AnimatedSprite2D.animation = 'walk'
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0



func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred('disabled', true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
