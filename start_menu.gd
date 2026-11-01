extends Control


func _on_on_mobile_button_pressed() -> void:
	GameSettings.is_mobile = true
	get_tree().change_scene_to_file("res://Scenes/main.tscn") 


func _on_on_pc_button_pressed() -> void:
	GameSettings.is_mobile = false
	get_tree().change_scene_to_file("res://Scenes/main.tscn") 
