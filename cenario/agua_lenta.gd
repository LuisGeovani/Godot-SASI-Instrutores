extends Area2D
# O CollisionShape2D precisa acompanhar a região pintada na camada Agua.
# Se o lago não for um retângulo, adicione mais CollisionShape2D dentro deste mesmo AguaLenta (não duplique o nó).
# collision_mask = 2 corresponde à camada física do Jogador.

@export_range(0.1, 1.0, 0.05) var multiplicador_velocidade: float = 0.5


func _ready() -> void:
	# Conecta os sinais de entrada e saída da área de água via código.
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D) -> void:
	if body is Jogador:
		body.speed_multiplier = multiplicador_velocidade


func _on_body_exited(body: Node2D) -> void:
	if body is Jogador:
		body.speed_multiplier = 1.0
