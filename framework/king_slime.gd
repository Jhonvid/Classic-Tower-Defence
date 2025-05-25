extends CharacterBody2D

@export var speed:float = 15.0
@export var vida_maxima:float = 600.0
var vida := 0.0

@onready var enemigopath: PathFollow2D = get_parent() 

var word_ref : word

func _physics_process(delta: float) -> void:
	enemigopath.progress = enemigopath.progress + (delta * speed)
	if enemigopath.progress_ratio >= 0.99:
		word_ref.take_damage(100.0)
		get_parent().queue_free()

func _ready() -> void:
	vida=vida_maxima
	$AnimatedSprite2D.play("default")

func take_damage (damage:float=1.0):
	vida -= damage
	$ProgressBar.value = (vida/vida_maxima)
	if vida <= 0:
		if word_ref:
			word_ref.coins+=300
			word_ref.update_coins()
		get_parent().queue_free()
		
func set_word_ref(ref):
	word_ref = ref
