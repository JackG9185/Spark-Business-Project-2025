extends Node2D


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/main/main_menu.tscn")
