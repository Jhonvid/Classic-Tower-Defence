extends Area2D

@export var speed:= 500 
@export var damage := 10.0
var direccion: Vector2

func set_target_position(new_target_pos:Vector2):
	look_at(new_target_pos)
	direccion = (new_target_pos - global_position).normalized()

	
func _physics_process(delta: float) -> void:
	position += direccion * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemigos"):
		body.take_damage(damage)
		queue_free()
		

func _on_timer_timeout() -> void:
	queue_free()
	
