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
	

func _physics_process(delta: float) -> void:
	health_pos = lerp(health_pos,target_health_pos, 0.4)
	$Polygon2D.polygon[1].x = health_pos
	$Polygon2D.polygon[0].x = health_pos
