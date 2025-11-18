extends Node2D


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/controls/controls_menu.tscn")


func _on_play_mouse_entered() -> void:
	$play.modulate = Color.GOLD

func _on_controls_mouse_entered() -> void:
	$controls.modulate = Color.GOLD

func _on_quit_mouse_entered() -> void:
	$quit.modulate = Color.GOLD

func _on_play_mouse_exited() -> void:
	$play.modulate = Color.WHITE

func _on_controls_mouse_exited() -> void:
	$controls.modulate = Color.WHITE

func _on_quit_mouse_exited() -> void:
	$quit.modulate = Color.WHITE
