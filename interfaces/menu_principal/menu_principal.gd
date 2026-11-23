extends Control

@export_file("*.tscn") var cena_fase: String = "res://fases/nivel_vila.tscn"

@onready var botao_novo_jogo: Button = $Cartao/Coluna/NovoJogo
@onready var botao_sair: Button = $Cartao/Coluna/Sair


func _ready() -> void:
	# Conecta os botões via código e coloca o foco inicial em Novo Jogo.
	botao_novo_jogo.pressed.connect(_on_novo_jogo_pressed)
	botao_sair.pressed.connect(_on_sair_pressed)
	botao_novo_jogo.grab_focus()


func _on_novo_jogo_pressed() -> void:
	get_tree().change_scene_to_file(cena_fase)


func _on_sair_pressed() -> void:
	get_tree().quit()
