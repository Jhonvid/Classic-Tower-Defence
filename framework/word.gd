extends Node2D
class_name word

@export var slime_normal: PackedScene
@export var slime_grande: PackedScene
@export var king_slime: PackedScene
@export var bat: PackedScene
@export var calaca: PackedScene
@export var demon: PackedScene
@export var duende: PackedScene

@export var max_tower_health := 100.0
var tower_health := 0.0

var coins := 300
var current_wave := 0
var current_index := 0
var current_wave_enemies := []

var build_mode := false
var can_build := false
var towe_build: PackedScene

@export var wave_delay := 3.0
@export var spawn_delay := 1.0

var spawn_timer: Timer
var wave_timer: Timer

func _ready():
	update_coins()
	tower_health = max_tower_health

	spawn_timer = Timer.new()
	spawn_timer.name = "SpawnTimer"
	add_child(spawn_timer)
	spawn_timer.timeout.connect(_on_spawn_next_enemy)

	wave_timer = Timer.new()
	wave_timer.name = "WaveTimer"
	add_child(wave_timer)
	wave_timer.timeout.connect(_on_start_next_wave)

	_on_start_next_wave()

func generar_oleada(n):
	var lista = []
	var cantidad = 5 + n * 2
	for i in range(cantidad):
		var r = randi() % 100
		if n >= 11 and r < 15:
			lista.append(king_slime)
		elif n >= 7 and r < 25:
			lista.append(demon)
		elif n >= 5 and r < 35:
			lista.append(slime_grande)
		elif n >= 4 and r < 50:
			lista.append(calaca)
		elif n >= 2 and r < 70:
			lista.append(duende)
		elif r < 85:
			lista.append(bat)
		else:
			lista.append(slime_normal)
	return lista

func _on_start_next_wave():
	print("🌊 Iniciando oleada ", current_wave + 1)
	$CanvasLayer/hud.update_wave(current_wave)
	current_wave_enemies = generar_oleada(current_wave)
	current_index = 0
	spawn_timer.start(spawn_delay)

func _on_spawn_next_enemy():
	if current_index < current_wave_enemies.size():
		var scene = current_wave_enemies[current_index]
		if scene:
			var enemigo = scene.instantiate()
			if "vida_maxima" in enemigo:
				enemigo.vida_maxima += current_wave * 10
			$Path2D.add_child(enemigo)
			assign_word_ref_to_children(enemigo, self)
		current_index += 1
		spawn_timer.start(spawn_delay)
	else:
		current_wave += 1
		_on_start_next_wave() # Inicia la siguiente ola inmediatamente

func assign_word_ref_to_children(node, ref):
	if node.has_method("set_word_ref"):
		node.set_word_ref(ref)
	for child in node.get_children():
		assign_word_ref_to_children(child, ref)

func toggle_build_mode(active: bool, sprite: Texture, tower_to_build: PackedScene):
	build_mode = active
	if build_mode:
		$builTower/Sprite2D.texture = sprite
		$builTower.visible = true
		towe_build = tower_to_build
	else:
		$builTower.visible = false
		towe_build = null

func _process(delta):
	$buildCheker.global_position = Vector2i(get_global_mouse_position() / 16) * 16
	$builTower.global_position = $buildCheker.global_position + Vector2(0, 8)

	if Input.is_action_just_pressed("build") and build_mode and can_build:
		var new_tower = towe_build.instantiate()
		add_child(new_tower)
		new_tower.global_position = $builTower.global_position + Vector2(0, 8)
		toggle_build_mode(false, null, null)

func _on_build_cheker_area_entered(area: Area2D):
	can_build = true

func _on_build_cheker_area_exited(area: Area2D):
	can_build = false

func update_coins():
	$CanvasLayer/hud.update_coins(coins)
	print("💰 Monedas:", coins)

func take_damage(damage: float):
	tower_health -= damage
	$Castillo/ProgressBar.value = tower_health / max_tower_health
	if tower_health <= 0:
		get_tree().reload_current_scene()
