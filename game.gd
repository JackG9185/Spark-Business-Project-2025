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
	if !leveling:
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


func _on_button_pressed() -> void: #dmg
	Gamestate.player.update_stats(Gamestate.player.max_hp,Gamestate.player.speed,Gamestate.player.dmg + 10,Gamestate.player.sht_spd)
	leveling = false

func _on_button_2_pressed() -> void: #spd
	Gamestate.player.update_stats(Gamestate.player.max_hp,Gamestate.player.speed + 50,Gamestate.player.dmg,Gamestate.player.sht_spd)
	leveling = false

func _on_button_3_pressed() -> void: #ss
	Gamestate.player.update_stats(Gamestate.player.max_hp,Gamestate.player.speed,Gamestate.player.dmg + 10,Gamestate.player.sht_spd + 1)
	leveling = false
