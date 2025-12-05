extends CanvasLayer
var health_pos := 0.0
var target_health_pos := 0.0
var wave = 0

var stats_up : bool = false

var on_cooldown: bool = false

@onready var health: Label = $health
@onready var player = Gamestate.player
@onready var stats_menu: Node2D = $stats_menu
@onready var cooldown: TextureProgressBar = $Dashicon/Cooldown
@onready var timer: Timer = $Dashicon/Timer

func _ready() -> void:
	$health.text = "100/100"
	
	$Wave.text = "Wave: " + str(wave)
	$enemies.text = "Enemies Left: "
	
	target_health_pos = %stickman.health * 5
	$Polygon2D.polygon[1].x = %stickman.health * 5
	$Polygon2D.polygon[0].x = %stickman.health * 5
	$Polygon2D2.polygon[3].x = %stickman.health * 5 + 4
	$Polygon2D2.polygon[2].x = %stickman.health * 5 + 4
	
	Gamestate.ui = self
	
	cooldown.max_value = timer.wait_time

func update_health(cur,max):
	health.text = str(cur) + "/" + str(max)

func update_ui(stat, num):
	if stat == "hp":
		target_health_pos = (float(Gamestate.player.health) / float(Gamestate.player.max_hp)) * 500
		update_health(Gamestate.player.health, Gamestate.player.max_hp)
func update_stats(hp,spd,dmg,ss):
	var format_string = "MAX HEALTH: %d \nSPEED: %d \nDAMAGE: %d \nFIRE RATE: %d/sec \n"
	var actual_string = format_string % [hp, spd, dmg, ss]
	$stats_menu/RichTextLabel.text = actual_string

func pause():
	Engine.time_scale = 0.0
	
func update_enemy_count():
	$enemies.text = "Enemies Left: " + str(Gamestate.spawner.left)
	$Wave.text = "Wave: " + str(Gamestate.spawner.wave_num + 1) + "\n"
	if Gamestate.spawner.left <= 0:
		$Wave.label_settings.font_color = Color(0.447, 244.878, 129.973, 1.0)
	else:
		$Wave.label_settings.font_color = Color(255, 255, 255, 1.0)
func _physics_process(delta: float) -> void:
	health_pos = lerp(health_pos,target_health_pos, 0.4)
	$Polygon2D.polygon[1].x = health_pos
	$Polygon2D.polygon[0].x = health_pos
	if Input.is_action_just_pressed("stats"):
		update_stats(player.max_hp,player.speed,player.dmg,player.sht_spd)
	if Input.is_action_pressed("stats"):
		stats_menu.position.x = lerp(stats_menu.position.x, 53.0, 0.15)
	else:
		stats_menu.position.x = lerp(stats_menu.position.x, -227.0, 0.15)
	
	if on_cooldown:
		cooldown.value = timer.time_left

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")
	$"../TileMapLayer".color = 0


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/main/main_menu.tscn")

func start_dash():
	if !on_cooldown:
		timer.start()
		on_cooldown = true
	print(on_cooldown)

func _on_timer_timeout() -> void:
	cooldown.value = 0
	on_cooldown = false
