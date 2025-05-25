extends StaticBody2D

@export var bullet_scene : PackedScene 

var current_objetivos
var total_objetivos:=[]
var can_disparar:bool = true 

func _process(delta: float) -> void: 
	if total_objetivos.size() > 0:
		for i in total_objetivos:
			if current_objetivos != null:
				if current_objetivos.get_parent().progress_ratio < i.get_parent().progress_ratio:
					current_objetivos = i 
			else:
				current_objetivos=i 
		if can_disparar:
			can_disparar = false
			disparar()
			$TimerCD.start()
			
			

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemigos"):
		if !total_objetivos.has(body):
			total_objetivos.append(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemigos"):
		if total_objetivos.has(body):
			total_objetivos.erase(body)

func disparar():
	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		add_child(bullet)
		bullet.set_target_position(current_objetivos.global_position)
		bullet.global_position = $Marker2D.global_position 
	
	
func _on_timer_cd_timeout() -> void:
	can_disparar = true
