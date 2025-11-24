extends Node2D


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/main/main_menu.tscn")


@export var tween_intensity: float
@export var tween_duration: float

@onready var back: Button = $Button

func _process(delta: float) -> void:
	btn_hovered(back)

func start_tween(object: Object, property: String, final_val: Variant, duration: float):
	var tween = create_tween()
	tween.tween_property(object, property, final_val, duration)

func btn_hovered(button: Button):
	button.pivot_offset = button.size / 2
	if button.is_hovered():
		start_tween(button, "scale", Vector2.ONE * tween_intensity, tween_duration)
	else:
		start_tween(button, "scale", Vector2.ONE, tween_duration)
