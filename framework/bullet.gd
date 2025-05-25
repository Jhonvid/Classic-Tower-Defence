extends Area2D

@export var speed := 200
@export var damage := 50.0
var direccion: Vector2
var target_enemy

func set_target_position(new_target_pos: Vector2):
	look_at(new_target_pos)
	direccion = (new_target_pos - global_position).normalized()
	
func _physics_process(delta: float) -> void:
	if target_enemy != null:
		direccion = (target_enemy.global_position - global_position).normalized()
		rotation = direccion.angle()


	position += direccion * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemigos"):
		body.take_damage(damage)
		queue_free()
		

func _on_timer_timeout() -> void:
	queue_free()
	
