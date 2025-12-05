extends Node2D

@onready var pause_menu = $UI/pause_menu
@onready var level_up_menu: Control = $"UI/Level up menu"
@onready var stars: Sprite2D = $Stars

var paused = false
var leveling = false
func _ready() -> void:
	pause_menu.hide()
	Engine.time_scale = 1

func _process(delta):
	stars.position.x += 0.1
	stars.position.y -= 0.1
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

var hp_add = 50
func _on_button_pressed() -> void: #dmg
	if leveling:
		Gamestate.player.update_stats(Gamestate.player.max_hp + hp_add,Gamestate.player.speed,Gamestate.player.dmg + 25,Gamestate.player.sht_spd)
		Gamestate.player.health += 60
		Gamestate.player.health = clamp(Gamestate.player.health, 10, Gamestate.player.max_hp)
		$UI.update_ui("hp",Gamestate.player.health)
		leveling = false

func _on_button_2_pressed() -> void: #spd
	if leveling:
		Gamestate.player.update_stats(Gamestate.player.max_hp + hp_add,Gamestate.player.speed + 50,Gamestate.player.dmg + 5,Gamestate.player.sht_spd)
		Gamestate.player.health += 60
		Gamestate.player.health = clamp(Gamestate.player.health, 10, Gamestate.player.max_hp)
		$UI.update_ui("hp",Gamestate.player.health)
		leveling = false

func _on_button_3_pressed() -> void: #ss
	if leveling:
		Gamestate.player.update_stats(Gamestate.player.max_hp + hp_add,Gamestate.player.speed,Gamestate.player.dmg + 5,Gamestate.player.sht_spd + 1)
		Gamestate.player.health += 60
		Gamestate.player.health = clamp(Gamestate.player.health, 10, Gamestate.player.max_hp)
		$UI.update_ui("hp",Gamestate.player.health)
		leveling = false
