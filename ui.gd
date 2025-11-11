extends CanvasLayer
var health_pos := 0.0
var target_health_pos := 0.0
var wave = 0
var stats_up : bool = false
@onready var health: Label = $health
@onready var player = Gamestate.player
@onready var stats_menu: Node2D = $stats_menu

func _ready() -> void:
	$health.text = "100/100"
	$Wave.text = "Wave: " + str(wave)
	target_health_pos = player.health * 5
	$Polygon2D.polygon[1].x = player.health * 5
	$Polygon2D.polygon[0].x = player.health * 5
	$Polygon2D2.polygon[1].x = player.health * 5 + 4
	$Polygon2D2.polygon[2].x = player.health * 5 + 4
func update_ui(stat, num):
	if stat == "hp":
		target_health_pos = num * 5
func update_health(cur,max):
	health.text = str(cur) + "/" + str(max)
func pause():
	Engine.time_scale = 0.0
	
func update_enemy_count():
	$Wave.text = "Wave: " + str(Gamestate.spawner.wave_num) #+ "\n" + "Enemies Left: " + str(Gamestate.spawner.left)
	if Gamestate.spawner.left <= 0:
		$Wave.label_settings.font_color = Color(0.447, 244.878, 129.973, 1.0)
	else:
		$Wave.label_settings.font_color = Color(255, 255, 255, 1.0)

func stats_toggle():
	if stats_up:
		stats_menu

func _physics_process(delta: float) -> void:
	
	health_pos = lerp(health_pos,target_health_pos, 0.4)
	$Polygon2D.polygon[1].x = health_pos
	$Polygon2D.polygon[0].x = health_pos


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
=======
	if Input.is_action_just_pressed("stats"):
		stats_toggle
>>>>>>> Stashed changes
