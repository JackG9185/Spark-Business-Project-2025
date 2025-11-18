extends Control


func _on_button_pressed() -> void:
	$".".hide()
	Engine.time_scale = 1
	$"../..".paused = false

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/main/main_menu.tscn")
