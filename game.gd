extends Node2D

@onready var pause_menu = $UI/pause_menu
@onready var level_up_menu: Control = $"UI/Level up menu"

var paused = false
var leveling = false
func _ready() -> void:
	pause_menu.hide()
	Engine.time_scale = 1

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
	if Input.is_action_just_pressed("dash"):
		leveling = !leveling
	if leveling:
		level_up_menu.global_position.y = lerp(level_up_menu.global_position.y,-740.0,0.1) 
	else:
		level_up_menu.global_position.y = lerp(level_up_menu.global_position.y,0.0,0.1)

func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	
	paused = !paused 
