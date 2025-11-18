extends Node2D
@onready var enemy1 = load("res://enemies/1/enemy.tscn")
@onready var enemy2 = load("res://enemies/2/enemy2.tscn")
@onready var main = get_tree().current_scene

var left := 0
var wave_data_path = "res://enemies/spawner/waves.json"
var wave_num = 0
var n = 0
const range = 300
var wave_file = {}
var wave_mod = 1.07

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
		instance.mod = wave_mod
	if type == "enemy2":
		var instance = enemy2.instantiate()
		instance.global_position = %stickman.global_position + Vector2(randi_range(-range/2,range/2),randi_range(-range/2,range/2))
		#%stickman.global_position = instance.global_position
		main.add_child.call_deferred(instance)
		instance.mod = wave_mod
func _physics_process(delta: float) -> void:
	print(wave_num)
	if $Timer.is_stopped():
		$Timer.start()

func _on_timer_timeout() -> void:
	do_wave(1, wave_file["waves"][wave_num])

func start_wave(rate, types):
	wave_mod = 1.07**wave_num
	for type in types:
		left += types[type]
	$"../UI".update_enemy_count()
	$Timer.wait_time = rate
	$Timer.start()
	$"../UI/Wave".text = "Wave: " + str(wave_num + 1)
	$"../UI/enemies".text = "Enemies Left: " + str(left)
	

func enemy_killed():
	left -= 1
	$"../UI".update_enemy_count()
	if left <= 0:
		print("NEXT WAVE")
		next_wave()

func do_wave(mod, types):
	for i in types:
		if types[i] > 0:
			spawn_enemy(i,mod)
			types[i] -= 1

func next_wave():
	wave_num += 1
	start_wave(1, wave_file["waves"][wave_num])
	
