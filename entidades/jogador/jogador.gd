extends CharacterBody2D
class_name Jogador

@export_category("Movimento")
@export var move_speed: float = 84.0

@export_category("Ataque")
@export var attack_cooldown: float = 0.35

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var facing: String = "down"
var is_attacking: bool = false
var cooldown_remaining: float = 0.0
# Multiplicador aplicado por áreas como a água lenta.
var speed_multiplier: float = 1.0


func _physics_process(delta: float) -> void:
	if cooldown_remaining > 0.0:
		cooldown_remaining = maxf(0.0, cooldown_remaining - delta)

	# ATAQUE EM ANDAMENTO
	if is_attacking:
		if animation_player.is_playing():
			return
		is_attacking = false

	# ATAQUE COM COOLDOWN
	if Input.is_action_just_pressed("attack") and cooldown_remaining <= 0.0:
		_start_attack()
		return

	# MOVIMENTACAO
	var input_direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	_update_facing(input_direction)
	velocity = input_direction * move_speed * speed_multiplier
	move_and_slide()

	# ANIMACAO
	var state: String = "idle" if input_direction == Vector2.ZERO else "walk"
	animation_player.play(state + "_" + facing)


func _start_attack() -> void:
	is_attacking = true
	cooldown_remaining = attack_cooldown
	velocity = Vector2.ZERO
	animation_player.play("attack_" + facing)


func _update_facing(direction: Vector2) -> void:
	if direction.x != 0.0:
		facing = "right" if direction.x > 0.0 else "left"
	elif direction.y != 0.0:
		facing = "down" if direction.y > 0.0 else "up"
