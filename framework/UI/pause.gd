extends Control


func _on_startt_button_down() -> void:
	get_tree().paused = false
	self.visible = false

func _on_exit_button_down() -> void:
	get_tree().change_scene_to_file("res://framework/UI/start.tscn")
