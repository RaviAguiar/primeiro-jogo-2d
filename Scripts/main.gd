extends Node
@export var mob_scene: PackedScene
var score

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game() -> void:
	score = 0
	$Player.start($StartPosition.position)
	$Player/AnimatedSprite2D.play('walk')
	$Player/AnimatedSprite2D.flip_v = false
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Começando...")
	get_tree().call_group('mobs', 'queue_free')
	$Music.play()

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	#cria uma var mob pra instanciar o inimigo da variável mob_scene (exportado via inspetor)

	var mob_spawn_location = $MobPath/MobSpawnLocation
	#cria a var de localização de spawn do mob com base no node MobSpawnLocation (filho de Path2D)
	mob_spawn_location.progress_ratio = randf()
	#seta a var criada para ser um número aleatório entre 0.0 e 1.0, o progress_ratio
	#quer dizer a porcentagem do caminho percorrido no path pelo MobSpawnLocation, então
	#se o número gerado for 1, isso representa o final do percurso pq o percurso vai justamente
	#de 0.0 a 1.0, e a função randf gera um número aleatório entre 0.0 e 1.0

	mob.position = mob_spawn_location.position
	#seta a posição do mob pra posição aletoria gerada no código em cima

	#essa variavel direction vai ser util pra a gente definir a direção do vetor que o inimigo vai usar pra se mover
	var direction = mob_spawn_location.rotation + PI / 2
	#por padrão a direção do mob vai ser seguindo a direção do caminho feito, se a gente
	#somar 90 graus a essa direção, vai fazer ele sempre virar pra tela. 
	#PI / 2 quer dizer 90 graus em radiano (pq o gdscript geralmente usa radiano pra representar angulos)

	direction += randf_range(-PI / 4, PI / 4)
	#pega a direção (perpendicular a linha do caminho) e soma um valor entre -45 e 45 graus
	#(se não entenderem estudem sobre ângulos em radiano)
	#btw diferente da func randf() que gera um random entre 0.0 e 1.0, a func randf_range()
	#geral um número entre x e y (incluindo y)
	mob.rotation = direction
	#pega o mob e seta a rotação dele pra a rotação meio aleatória que a gente criou
	#cria a variável velocidade e faz ela ser um vetor de valor (com x e y)
	#o x representa uma speed aleatória entre 150 e 250 e o y é 0 pq asism ele vai
	#estar virado para a direita (angulo 0) isso vai ser importante pra a gente rotacionar
	#esse vetor pra o valor aleatorio de direction que a gente setou
	var velocity = Vector2(randf_range(150, 250), 0)
	#pega a propriedade de velocidade linear do mob e associa ela a velocidade que a gente criou,
	#além disso, ele rotaciona esse vetor pra direção aleatória que a gente setou antes
	mob.linear_velocity = velocity.rotated(direction)

	add_child(mob)
	#spawna o mob na cena principal

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
