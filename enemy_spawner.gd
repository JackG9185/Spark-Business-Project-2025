extends Node2D
@onready var enemy1 = load("res://enemy.tscn")
@onready var enemy2 = load("res://enemy2.tscn")
@onready var main = get_tree().current_scene

var left := 0
var wave_data_path = "res://waves.json"
var wave_num = 0
var n = 0
var canSpawn := false
const range = 300
var wave_file = {}
var wave1 = {
	"enemy": 10,
	"enemy2": 4
}

func load_json(filePath):
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath,FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		if parsedResult is Dictionary:
			return parsedResult
		else:
			print("error reading file :(")
	else:
		print("Nope! Try a file that exists next time!")

func _ready() -> void:
	Gamestate.spawner = self
	
	wave_file = load_json(wave_data_path)
	#print(wave_file["waves"][0])
	start_wave(1, wave_file["waves"][wave_num])

func spawn_enemy(type, mod):
	if type == "enemy":
		var instance = enemy1.instantiate()
		instance.global_position = %stickman.global_position + Vector2(randi_range(-range,range),randi_range(-range,range))
		#%stickman.global_position = instance.global_position
		main.add_child.call_deferred(instance)
	if type == "enemy2":
		var instance = enemy2.instantiate()
		instance.global_position = %stickman.global_position + Vector2(randi_range(-range/2,range/2),randi_range(-range/2,range/2))
		#%stickman.global_position = instance.global_position
		main.add_child.call_deferred(instance)

func _physics_process(delta: float) -> void:
	if $Timer.is_stopped():
		print("ADIHASLJDKJSAHNKADS")
		$Timer.start()

func _on_timer_timeout() -> void:
	do_wave(1, wave_file["waves"][wave_num])
	if canSpawn:
		n -= 1
		spawn_enemy("enemy2",1)

func start_wave(rate, types):
	for type in types:
		left += types[type]

	wave_num += 1
	$Timer.wait_time = rate
	$Timer.start()
	$"../UI/Wave".text = "Wave: " + str(wave_num)
	$"../UI/enemies".text = "Enemies Left: " + str(left)

func enemy_killed():
	left -= 1
	$"../UI".update_enemy_count()

func do_wave(mod, types):
	for i in types:
		if types[i] > 0:
			spawn_enemy(i,1)
			types[i] -= 1
