extends Node2D

@export var largura_mapa: int = 512
@export var altura_mapa: int = 320

@onready var camera_jogador: Camera2D = $Jogador/Camera2D


func _ready() -> void:
	# Limita a câmera ao tamanho da vila (32 x 20 tiles de 16 px).
	camera_jogador.limit_left = 0
	camera_jogador.limit_top = 0
	camera_jogador.limit_right = largura_mapa
	camera_jogador.limit_bottom = altura_mapa
