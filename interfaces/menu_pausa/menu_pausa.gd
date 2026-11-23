extends CanvasLayer

@export_file("*.tscn") var cena_menu: String = "res://interfaces/menu_principal/menu_principal.tscn"

@onready var botao_continuar: Button = $Fundo/Centro/Cartao/Coluna/Continuar
@onready var botao_menu_principal: Button = $Fundo/Centro/Cartao/Coluna/MenuPrincipal


func _ready() -> void:
	# Garante que o menu comece oculto e conecta os botões via código.
	visible = false
	botao_continuar.pressed.connect(_on_continuar_pressed)
	botao_menu_principal.pressed.connect(_on_menu_principal_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and not event.is_echo():
		_alternar_pausa()
		get_viewport().set_input_as_handled()


func _alternar_pausa() -> void:
	var pausado: bool = not get_tree().paused
	get_tree().paused = pausado
	visible = pausado
	if pausado:
		botao_continuar.grab_focus()


func _on_continuar_pressed() -> void:
	get_tree().paused = false
	visible = false


func _on_menu_principal_pressed() -> void:
	# Despausa antes de trocar de cena para o menu inicial não ficar congelado.
	get_tree().paused = false
	visible = false
	get_tree().change_scene_to_file(cena_menu)
