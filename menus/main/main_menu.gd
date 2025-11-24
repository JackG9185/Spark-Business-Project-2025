extends Node2D


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/controls/controls_menu.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/credits/credits_menu.tscn")
