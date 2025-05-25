extends Control

@export var world_ref: word
@export var towers : Array[PackedScene] = []
@export var textures : Array[Texture] = []

var pause_menu: Control

func _ready():
	pause_menu = preload("res://framework/UI/pause.tscn").instantiate()
	get_tree().root.add_child(pause_menu)
	pause_menu.visible = false

func update_coins(coins:int):
	$Label.text = "coins:" + str(coins)

func start_build_mode(tower_ref:PackedScene, texture:Texture):
	world_ref.toggle_build_mode(true, texture, tower_ref)

func _on_arqueras_button_down() -> void:
	if world_ref.coins >= 300:
		start_build_mode(towers[0], textures[0])
		world_ref.coins -= 300
		world_ref.update_coins()

func _on_cañon_button_down() -> void:
	if world_ref.coins >= 500:
		start_build_mode(towers[1], textures[1])
		world_ref.coins -= 500
		world_ref.update_coins()

func _on_vallesta_button_down() -> void:
	if world_ref.coins >= 4000:
		start_build_mode(towers[2], textures[2])
		world_ref.coins -= 4000
		world_ref.update_coins()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = true
		get_tree().change_scene_to_file("res://framework/UI/pause.tscn")
		pause_menu.visible = true
		
func update_wave(wave: int):
	$WaveLabel.text = "Oleada: %d" % wave
