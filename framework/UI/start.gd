extends Control

func _ready():
	get_tree().paused = true
	


func _on_startt_button_down() -> void:
	get_tree().paused = false
	self.visible = false

func _on_exit_button_down() -> void:
	get_tree().quit()
