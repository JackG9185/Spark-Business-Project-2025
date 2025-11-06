extends CanvasLayer
var health_pos := 0.0
var target_health_pos := 0.0
var wave = 0
func _ready() -> void:
	$Wave.text = "Wave: " + str(wave)
	target_health_pos = %stickman.health * 5
	$Polygon2D.polygon[1].x = %stickman.health * 5
	$Polygon2D.polygon[0].x = %stickman.health * 5
func update_ui(stat, num):
	if stat == "hp":
		print($Polygon2D.polygon)
		target_health_pos = num * 5

func pause():
	Engine.time_scale = 0.0
	
func update_enemy_count():
	$Wave.text = "Wave: " + str(Gamestate.spawner.wave_num) + "\n" + "Enemies Left: " + str(Gamestate.spawner.left)
	if Gamestate.spawner.left <= 0:
		$Wave.label_settings.font_color = Color(0.447, 244.878, 129.973, 1.0)
	else:
		$Wave.label_settings.font_color = Color(255, 255, 255, 1.0)
func _physics_process(delta: float) -> void:
	health_pos = lerp(health_pos,target_health_pos, 0.4)
	$Polygon2D.polygon[1].x = health_pos
	$Polygon2D.polygon[0].x = health_pos
