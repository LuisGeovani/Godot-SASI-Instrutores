# Trilhas da Vila — Projeto dos Instrutores (Minicurso Godot SASI)

Projeto completo de referência ("cola" de aula) para **Luís Geovani** e **Caio Pontes** no minicurso *Desvendando a Godot: Crie seu primeiro jogo* (SASI 2026 · LASI / CCET / UFAC · 24/11/2026).

- **Engine:** Godot 4.7.2 (`GL Compatibility`)
- **Escopo enxuto (construído do zero em sala):** cenário em `TileMapLayer` com colisões, personagem que anda nas 4 direções e ataca (`Espaço`) com cooldown, menu inicial (`Novo Jogo` / `Sair`) e menu de pausa (`Esc`: `Continuar` / `Menu Principal`).
- **Divisão de condução:**
  - **Luís:** cenário (`TileSet` / `TileMapLayer` / câmera da fase) e interfaces (`MenuPrincipal` e `MenuPausa`).
  - **Caio:** jogador (`CharacterBody2D`, animações, movimento, ataque com cooldown) e exportação/publicação.
- **Repositório dos alunos (`Godot-SASI` / `projeto_base/`):** contém os 14 arquivos CC0 em `assets/` (incluindo `bau.png`, `aldeao.png` e `tesouro.wav` para atividades pós-aula e game jams), `creditos.txt`, `README.md` e um `project.godot` mínimo (já com janela `400×240`, substituição `800×480`, `stretch/mode = viewport`, filtro `Nearest` e `GL Compatibility`, mas **sem** cenas, **sem** scripts, **sem** Mapa de Entrada e **sem** Cena Principal).
- **Convenções locais do projeto:** os arquivos `.tscn` e `.gd` usam `snake_case` (`terreno.tscn`, `nivel_vila.tscn`, `menu_principal.tscn`, `menu_pausa.tscn`) para manter correspondência direta com os slides do minicurso. As camadas de mapa ficam agrupadas em `cenario/terreno.tscn` para demonstrar reaproveitamento de subcena (instanciada em `nivel_vila.tscn` e, opcionalmente, como fundo de `menu_principal.tscn`).

---

## Controles e Mapa de Entrada

Configure exatamente estas 5 ações em **Projeto → Configurações do Projeto... → Mapa de Entrada** (`ui_cancel` já vem pronta na Godot):

| Ação | Teclas | Uso |
| :--- | :--- | :--- |
| `move_left` | `A`, `←` | Mover para a esquerda |
| `move_right` | `D`, `→` | Mover para a direita |
| `move_up` | `W`, `↑` | Mover para cima |
| `move_down` | `S`, `↓` | Mover para baixo |
| `attack` | `Espaço` | Atacar na direção atual (com cooldown) |
| `ui_cancel` *(nativa — não criar)* | `Esc` | Abrir/fechar menu de pausa |

---

## Atalhos de sobrevivência no editor (Godot 4.7.2 `pt_BR`)

Vale avisar a turma antes de começar a editar:

- `Ctrl+S` — salvar a cena atual (`Ctrl+Shift+S` salva todas as cenas abertas)
- `Ctrl+Z` — desfazer
- `Espaço + arrastar` ou botão do meio do mouse — mover a câmera na Viewport 2D
- `Scroll` — zoom na Viewport 2D
- `F` — centralizar no nó selecionado (salva quem se perde no mapa)
- `Ctrl+A` — criar novo nó filho
- `Ctrl+Shift+A` — instanciar cena filha (`.tscn`)
- `F5` — executar projeto (Cena Principal)
- `F6` — executar a cena atual
- `F8` — parar o jogo em execução

---

## Roteiro da aula (ordem de construção do zero)

### Etapa 0 — Importar o projeto-base e configurar entrada *(Luís / Caio)*

1. **Baixar e extrair antes de abrir:** os alunos **não** criam projeto novo do zero na tela inicial. Eles baixam o repositório `Godot-SASI` (**Code → Download ZIP** ou `git clone`) e **extraem a pasta** antes de abrir na Godot (não abrir de dentro do `.zip`).
2. **Importar na Godot 4.7.2:** no **Gerenciador de Projetos**, clicar em **Importar**, selecionar o arquivo `project.godot` da pasta extraída e abrir.
   - O `project.godot` do repositório já vem configurado em `GL Compatibility`, janela pixel art (`400 × 240`, substituição `800 × 480`, `stretch/mode = viewport`) e filtro de textura `Nearest` (`default_texture_filter = 0`).
3. **Idioma `pt_BR`:** `Editor → Configurações do Editor... → Geral → Interface → Editor → Localização → Idioma do Editor` → `[pt_BR] Portuguese, Brazil`.
   - **Armadilha:** a mudança só entra em vigor depois de clicar em **Salvar e Reiniciar**.
4. **Mapa de Entrada:** abrir `Projeto → Configurações do Projeto... → Mapa de Entrada` e criar `move_left`, `move_right`, `move_up`, `move_down` e `attack` conforme a tabela acima (`ui_cancel` já existe por padrão).

---

### Etapa 1 — TileSet e cenário da vila *(Conduz: Luís)*

#### 1.1 Criar `cenario/terreno.tscn` e o recurso `cenario/tileset.tres` passo a passo

1. Criar nova cena (`Cena → Nova Cena`) com raiz `Terreno` (`Node2D`, ativar **`y_sort_enabled = true`** no Inspetor) e salvar em `cenario/terreno.tscn`.
2. Adicionar um filho `TileMapLayer` (`Ctrl+A`), renomear para `Chao` e ajustar `z_index = -3`.
3. No Inspetor de `Chao`, em **Tile Set**, clicar em `<vazio> → Novo TileSet` (a grade padrão já é `16 × 16`). Clicar na seta ao lado do `TileSet` → **Salvar como...** → salvar em `cenario/tileset.tres` (assim todas as camadas compartilham o mesmo recurso).
4. Ainda no Inspetor do `TileSet`, abrir **Camadas de Física → Adicionar Elemento** (`Camada de Física 0`: `collision_layer = 1`, `collision_mask = 2`).
5. Abrir a aba inferior **TileSet**, clicar em **Tiles** e arrastar cada PNG de `assets/cenario/` (`solo.png`, `agua.png`, `natureza.png`, `casas.png`, `piso.png`, `parede.png`) para o painel de fontes (*Atlas Source*). Quando a Godot perguntar se deseja criar tiles automaticamente nas áreas não transparentes, confirmar **Sim**.
6. Na aba **TileSet → Pintar**, selecionar **Camada de Física 0**. Com o editor de polígono em foco, pressionar `F` ou usar o menu de redefinição para criar a forma padrão do tile. Conferir no painel central o quadrado de `16 × 16` (`(-8, -8)` a `(8, 8)`) e só então clicar nos tiles de arbusto/borda em `natureza.png`, água em `agua.png` e paredes em `parede.png` para aplicar a colisão.
7. Adicionar as demais camadas `TileMapLayer` filhas de `Terreno`, atribuindo o mesmo `cenario/tileset.tres` em todas:
   - `Chao` (`z_index = -3`)
   - `Agua` (`z_index = -2`)
   - `ChaoFlorido` (`z_index = -1`, opcional)
   - `Natureza` (`y_sort_enabled = true`)
   - `Casas` (`y_sort_enabled = true`, opcional)

#### 1.2 Pintura mínima garantida (para toda a turma funcionar sem travar)

- **Armadilha de sala:** selecionar o nó `Terreno` **não** abre a aba `TileMap` no rodapé — é preciso expandir `Terreno` e clicar em uma camada filha (`TileMapLayer`).
- **Ritmo:** marque um cronômetro de **10 min** na pintura para não estourar o bloco.
- **Regras mínimas obrigatórias para bater com câmera e spawn:**
  1. Na camada `Chao`, pintar um retângulo de **32 × 20 células** começando em **`(0, 0)` até `(31, 19)`** (`512 × 320 px`, exatamente o limite de câmera de `fase.gd`).
  2. Na camada `Natureza`, fechar toda a **borda externa** (`x = 0`, `x = 31`, `y = 0`, `y = 19`) com um tile com colisão (ex.: arbusto `0:10` de `natureza.png`), impedindo o jogador de sair do mapa.
  3. Manter a área ao redor de **`(232, 178)`** (células `(13..16, 10..12)`) **livre de obstáculos e água** para o spawn do personagem.
  4. Pintar um pequeno trecho em `Agua` (com colisão na `Camada de Física 0`) fora do ponto de spawn para testar colisão e deslizamento.

#### 1.3 Referência opcional — vila completa (`cenario/tileset.tres`)

Quem quiser reproduzir exatamente a vila de referência pode configurar os tiles multi-célula no `TileSet` (`Configuração` → selecionar região → `Tamanho no Atlas`, `Origem da Textura` e polígono na `Camada de Física 0`):

- **Árvores (`natureza.png`):** coordenadas `0:0` e `2:0`, `size_in_atlas = Vector2i(2, 2)`, `texture_origin = Vector2i(0, 8)`, polígono no tronco `PackedVector2Array(-7, -5, 7, -5, 7, 5, -7, 5)`. Arbusto de borda: `0:10` (`1 × 1`, colisão inteira `(-8, -8)` a `(8, 8)`).
- **Casas (`casas.png`):** coordenadas `0:0` e `12:0`, `size_in_atlas = Vector2i(4, 3)`, `texture_origin = Vector2i(0, 16)`, polígono na base `PackedVector2Array(-26, -17, 26, -17, 26, 5, -26, 5)`.
- **Distribuição na referência (`terreno.tscn`):** `Chao` (`640` células, `(0, 0)..(31, 19)`), `Agua` (`28` células, `(20, 13)..(26, 16)`), `ChaoFlorido` (`10` flores decorativas), `Natureza` (`110` células com borda fechada + árvores) e `Casas` (`2` casas em `(9, 4)` e `(21, 4)`).

#### 1.4 Criar a cena da fase `fases/nivel_vila.tscn`

1. Criar nova cena com raiz `Vila` (`Node2D`, `y_sort_enabled = true`) e salvar em `fases/nivel_vila.tscn`.
2. Instanciar `cenario/terreno.tscn` dentro de `Vila` (`Ctrl+Shift+A`).
3. Após instanciar `Jogador` na Etapa 2, anexar `fases/fase.gd` na raiz `Vila`:

```gdscript
# fases/fase.gd (estilo Luís)
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
```

---

### Etapa 2 — Cena do jogador, animações e movimento *(Conduz: Caio)*

#### 2.1 Montar `entidades/jogador/jogador.tscn`

1. Criar nova cena com raiz `Jogador` (`CharacterBody2D`) e salvar em `entidades/jogador/jogador.tscn`.
   - No Inspetor de `Jogador`: `Motion Mode = Floating (1)`, `Collision → Layer = 2`, `Mask = 1`.
2. Adicionar os 4 nós filhos de `Jogador`:
   - `Sprite2D`: `position = Vector2(0, -6)`, arrastar `assets/personagens/hunter.png` (ou qualquer outro dos personagens da pasta) para `Texture`, e em `Animation` configurar `Hframes = 4`, `Vframes = 7`.
   - `CollisionShape2D`: `position = Vector2(0, -1)`, `Shape = Novo CircleShape2D` com `radius = 5.0` (nos pés).
   - `AnimationPlayer`: para controlar `Sprite2D:frame`.
   - `Camera2D`: acompanha o personagem pela fase.

#### 2.2 Como gravar quadros-chave no `AnimationPlayer` e tabela completa dos 12 clipes

1. Clicar em `AnimationPlayer` e abrir a aba inferior **Animação**.
2. Para cada clipe: clicar em **Animação → Nova...**, digitar o nome exato, ajustar a **Duração** (campo à direita) e ligar/desligar o botão de **Loop** (setas circulares).
3. Antes de gravar, configurar o ajuste (snap) em segundos com passo de `0,01 s` e conferir os tempos na régua. Nos ataques, manter as chaves repetidas nos dois instantes indicados.
4. Com o tempo em `0.00 s`, selecionar `Sprite2D` na árvore, definir o número de `Animation → Frame` no Inspetor e clicar no ícone de **chave** ao lado de `Frame` (na 1ª chave, confirmar a criação da faixa `Sprite2D:frame`; manter atualização discreta sem interpolação).
5. Arrastar a linha vertical do tempo para o próximo instante da tabela, mudar `Frame` e clicar novamente na **chave**.

Na Etapa 2, crie os 8 clipes de `idle_*` e `walk_*` (os 4 clipes de `attack_*` entram na Etapa 3):

| Clipe | Duração | Loop | Tempos das chaves (s) | Quadros (`Sprite2D:frame`) |
| :--- | :---: | :---: | :--- | :--- |
| `idle_down` | `0.24 s` | Sim (`1`) | `0.00` | `[0]` |
| `idle_up` | `0.24 s` | Sim (`1`) | `0.00` | `[1]` |
| `idle_left` | `0.24 s` | Sim (`1`) | `0.00` | `[2]` |
| `idle_right` | `0.24 s` | Sim (`1`) | `0.00` | `[3]` |
| `walk_down` | `0.52 s` | Sim (`1`) | `0.00, 0.13, 0.26, 0.39` | `[4, 0, 12, 0]` |
| `walk_up` | `0.52 s` | Sim (`1`) | `0.00, 0.13, 0.26, 0.39` | `[5, 1, 13, 1]` |
| `walk_left` | `0.52 s` | Sim (`1`) | `0.00, 0.13, 0.26, 0.39` | `[6, 2, 14, 2]` |
| `walk_right` | `0.52 s` | Sim (`1`) | `0.00, 0.13, 0.26, 0.39` | `[7, 3, 15, 3]` |
| `attack_down` *(Etapa 3)* | `0.24 s` | Não (`0`) | `0.00, 0.08, 0.16` | `[0, 16, 16]` |
| `attack_up` *(Etapa 3)* | `0.24 s` | Não (`0`) | `0.00, 0.08, 0.16` | `[1, 17, 17]` |
| `attack_left` *(Etapa 3)* | `0.24 s` | Não (`0`) | `0.00, 0.08, 0.16` | `[2, 18, 18]` |
| `attack_right` *(Etapa 3)* | `0.24 s` | Não (`0`) | `0.00, 0.08, 0.16` | `[3, 19, 19]` |

#### 2.3 Script intermediário (só movimento) e primeiro teste com `F6`

1. **Dentro da cena `entidades/jogador/jogador.tscn`**, selecionar o nó raiz `Jogador` e anexar o script `entidades/jogador/jogador.gd` com a versão intermediária abaixo (funciona sozinha no primeiro teste, antes de criar as animações de ataque):

```gdscript
# entidades/jogador/jogador.gd — versão intermediária (Etapa 2: só movimento)
extends CharacterBody2D

@export_category("Movimento")
@export var move_speed: float = 84.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var facing: String = "down"


func _physics_process(_delta: float) -> void:
	# MOVIMENTACAO
	var input_direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	_update_facing(input_direction)
	velocity = input_direction * move_speed
	move_and_slide()

	# ANIMACAO
	var state: String = "idle" if input_direction == Vector2.ZERO else "walk"
	animation_player.play(state + "_" + facing)


func _update_facing(direction: Vector2) -> void:
	if direction.x != 0.0:
		facing = "right" if direction.x > 0.0 else "left"
	elif direction.y != 0.0:
		facing = "down" if direction.y > 0.0 else "up"
```

2. Salvar `jogador.tscn` (`Ctrl+S`), abrir `fases/nivel_vila.tscn`, instanciar `entidades/jogador/jogador.tscn` (`Ctrl+Shift+A`) em `position = Vector2(232, 178)` e anexar `fases/fase.gd` na raiz `Vila`.
3. **Armadilha de sala:** salve todas as cenas (`Ctrl+Shift+S`) e **volte para a aba `fases/nivel_vila.tscn` antes de apertar `F6`**. Rodar `F6` com `jogador.tscn` aberta mostra apenas o personagem e a câmera num fundo vazio (sem o mapa nem as colisões da vila).

---

### Etapa 3 — Ação de ataque com cooldown *(Conduz: Caio)*

1. Em `entidades/jogador/jogador.tscn`, criar no `AnimationPlayer` os 4 clipes de ataque da tabela acima (`attack_down`, `attack_up`, `attack_left`, `attack_right`, duração `0.24 s`, **sem loop**, tempos `0.00 / 0.08 / 0.16 s`).
2. Evoluir `entidades/jogador/jogador.gd` para a versão final completa com `@export_category("Ataque")`, `attack_cooldown`, `cooldown_remaining` e `Input.is_action_just_pressed("attack")`:

```gdscript
# entidades/jogador/jogador.gd (estilo Caio — versão final)
extends CharacterBody2D

@export_category("Movimento")
@export var move_speed: float = 84.0

@export_category("Ataque")
@export var attack_cooldown: float = 0.35

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var facing: String = "down"
var is_attacking: bool = false
var cooldown_remaining: float = 0.0


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
	velocity = input_direction * move_speed
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
```

3. Salvar (`Ctrl+Shift+S`) e testar andar, colidir e atacar com `Espaço` nas 4 direções em `fases/nivel_vila.tscn` (`F6`).

---

### Etapa 4 — Menu inicial *(Conduz: Luís)*

1. Criar `interfaces/menu_principal/menu_principal.tscn`:
   - **Estrutura essencial:**
     - Raiz `MenuPrincipal` (`Control`, predefinição de âncoras **Retângulo Completo** / `anchors_preset = 15`).
     - `Cartao` (`PanelContainer`): `offset_left = 20`, `offset_top = 34`, `offset_right = 210`.
     - `Coluna` (`VBoxContainer`, filho de `Cartao`, `theme_override_constants/separation = 5`):
       - `Titulo` (`Label`, texto `"Trilhas da Vila"`, `font_size = 22`)
       - `NovoJogo` (`Button`, texto `"Novo Jogo"`, `custom_minimum_size = Vector2(0, 23)`)
       - `Sair` (`Button`, texto `"Sair"`, `custom_minimum_size = Vector2(0, 23)`)
   - **Aparência opcional (usada na cena de referência `menu_principal.tscn`):**
     - `Paisagem`: instância de `cenario/terreno.tscn` como 1º filho de `MenuPrincipal`, em `position = Vector2(-70, -36)`.
     - `Sombra` (`ColorRect`, filho de `MenuPrincipal`, âncoras **Retângulo Completo**, `mouse_filter = Ignore (2)`, `color = Color(0.05, 0.11, 0.13, 0.35)`).
     - Dentro de `Coluna`: `Evento` (`Label`, `"SASI   /   UFAC"`, `font_size = 11`, cor dourada), `Subtitulo` (`Label`, `"Minicurso Desvendando a Godot"`, `font_size = 10`) e `Espaco` (`Control`, `custom_minimum_size = Vector2(0, 3)` acima dos botões).
     - `Creditos` (`PanelContainer`, filho de `MenuPrincipal`, `offset_left = 20`, `offset_top = 204`) → `Arte` (`Label`, `"Arte: Ninja Adventure (Pixel-boy, CC0)"`, `font_size = 10`).
2. Anexar `interfaces/menu_principal/menu_principal.gd` na raiz `MenuPrincipal`, conectando os sinais no `_ready()` via código:

```gdscript
# interfaces/menu_principal/menu_principal.gd (estilo Luís)
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
```

3. Definir como cena principal em **Projeto → Configurações do Projeto... → Geral → Aplicação → Executar → Cena Principal** → `res://interfaces/menu_principal/menu_principal.tscn`.
4. **Armadilha de sala:** salvar (`Ctrl+S`) antes de testar o fluxo completo com `F5`.

---

### Etapa 5 — Menu de pausa *(Conduz: Luís)*

1. Criar `interfaces/menu_pausa/menu_pausa.tscn`:
   - Raiz `MenuPausa` (`CanvasLayer`, `layer = 4`, `visible = false`).
   - Ajustar no Inspetor: **`Node → Process → Mode = Always`** (`process_mode = 3`).
   - **Armadilha de sala:** na Godot 4.7.2 em `pt_BR`, a opção continua aparecendo em inglês como **`Always`** (não "Sempre").
   - Filhos (atenção às âncoras **Retângulo Completo** para cobrir a tela e centralizar o cartão):
     - `Fundo` (`ColorRect`, âncoras **Retângulo Completo** / `anchors_preset = 15`, `color = Color(0.06, 0.13, 0.14, 0.72)`).
     - `Centro` (`CenterContainer`, filho de `Fundo`, âncoras **Retângulo Completo** / `anchors_preset = 15`).
     - `Cartao` (`PanelContainer`, filho de `Centro`, `custom_minimum_size = Vector2(150, 0)`).
     - `Coluna` (`VBoxContainer`, filho de `Cartao`, `theme_override_constants/separation = 7`) → `Titulo` (`Label`, `"Jogo pausado"`, `horizontal_alignment = Center`, `font_size = 18`), `Continuar` (`Button`, `Text = "Continuar"`, `custom_minimum_size = Vector2(0, 23)`) e `MenuPrincipal` (`Button`, `Text = "Menu Principal"`, `custom_minimum_size = Vector2(0, 23)`).
2. Anexar `interfaces/menu_pausa/menu_pausa.gd` na raiz `MenuPausa`:

```gdscript
# interfaces/menu_pausa/menu_pausa.gd (estilo Luís)
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
```

3. Instanciar `interfaces/menu_pausa/menu_pausa.tscn` dentro de `fases/nivel_vila.tscn` (`Ctrl+Shift+A`).
4. **Armadilha de sala:** salvar todas as cenas (`Ctrl+Shift+S`) antes de testar com `F5`, e testar **Esc → Continuar** e **Esc → Menu Principal → Novo Jogo** (para confirmar que despausou antes da troca de cena).

---

### Etapa 6 — Exportação para Windows e itch.io *(Conduz: Caio)*

1. **Checklist antecipado (15h00):** enquanto a turma pinta o cenário, o segundo ministrante já confere nas bancadas se os **Modelos de Exportação 4.7.2** estão instalados e se as contas no **itch.io** abrem.
   - **Plano B offline (pen drive):** `Editor → Gerenciar Modelos de Exportação... → Instalar de Arquivo...` selecionando o `.tpz` da Godot 4.7.2.
2. Acessar **Projeto → Exportar...**, clicar em **Adicionar... → Windows Desktop** (nos projetos dos alunos que começam sem `export_presets.cfg`) e clicar em **Exportar Projeto...** *(atenção: não clicar em "Exportar PCK/Zip...")*.
3. **Armadilha de pasta:** criar ou confirmar a pasta `build/windows/` no diálogo de salvar (`build/windows/minicurso.exe`), evitando misturar `.exe`/`.pck` com `project.godot`.
4. Com `embed_pck = false`, manter `minicurso.exe` e `minicurso.pck` juntos. Compactar os dois pelo menu nativo do Windows Explorer em `.zip`, extrair em outra pasta e testar com a Godot fechada.
5. **Armadilha do Windows Defender SmartScreen:** executável sem assinatura dispara a tela azul ("O Windows protegeu o computador") → clicar em **Mais informações → Executar assim mesmo**.
6. No **itch.io**, criar projeto *Downloadable*, enviar o `.zip`, marcar **Windows** e salvar em rascunho (**Draft**) ou publicar (**Public**).

---

## Créditos

- Arte e efeitos: **Ninja Adventure Asset Pack** — Pixel-boy (CC0 1.0 Universal · `https://pixel-boy.itch.io/ninja-adventure-asset-pack`). Veja `creditos.txt`.
