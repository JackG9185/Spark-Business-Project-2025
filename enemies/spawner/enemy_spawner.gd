extends Node2D
@onready var enemy1 = load("res://enemies/1/enemy.tscn")
@onready var enemy1b = load("res://enemies/1b/enemy_1b.tscn")
@onready var enemy1c = load("res://enemies/1c/enemy_1c.tscn")
@onready var enemy2 = load("res://enemies/2/enemy2.tscn")
@onready var enemy2b = load("res://enemies/2b/enemy2b.tscn")
@onready var enemy2c = load("res://enemies/2c/enemy2c.tscn")
@onready var boss = load("res://enemies/boss/boss.tscn")
@onready var main = get_tree().current_scene
@onready var enemy_die: AudioStreamPlayer = $EnemyDie



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
	start_wave(1, wave_file["waves"][wave_num%25])

func get_spawn_coords(dist):
	var pos = Vector2(randi_range(-352,1792),randi_range(-128,960))
	while pos.distance_squared_to(Gamestate.player.global_position) <= dist:
		pos = Vector2(randi_range(-352,1792),randi_range(-128,960))
	return pos
func spawn_enemy(type, mod):
	if type == "enemy":
		var instance = enemy1.instantiate()
		instance.global_position = get_spawn_coords(1000)
		#%stickman.global_position = instance.global_position
		main.add_child.call_deferred(instance)
		instance.mod = wave_mod
	if type == "enemyB":
		var instance = enemy1b.instantiate()
		instance.global_position = get_spawn_coords(1000)
		#%stickman.global_position = instance.global_position
		main.add_child.call_deferred(instance)
		instance.mod = wave_mod
	if type == "enemyC":
		var instance = enemy1c.instantiate()
		instance.global_position = get_spawn_coords(1000)
		#%stickman.global_position = instance.global_position
		main.add_child.call_deferred(instance)
		instance.mod = wave_mod
	if type == "enemy2":
		var instance = enemy2.instantiate()
		instance.global_position = get_spawn_coords(1000)
		#%stickman.global_position = instance.global_position
		main.add_child.call_deferred(instance)
		instance.mod = wave_mod
	if type == "enemy2B":
		var instance = enemy2b.instantiate()
		instance.global_position = get_spawn_coords(1000)
		#%stickman.global_position = instance.global_position
		main.add_child.call_deferred(instance)
		instance.mod = wave_mod
	if type == "enemy2C":
		var instance = enemy2c.instantiate()
		instance.global_position = get_spawn_coords(1000)
		#%stickman.global_position = instance.global_position
		main.add_child.call_deferred(instance)
		instance.mod = wave_mod
	if type == "Boss":
		var instance = boss.instantiate()
		instance.global_position = get_spawn_coords(1500)
		#%stickman.global_position = instance.global_position
		main.add_child.call_deferred(instance)
		instance.mod = wave_mod
func _physics_process(delta: float) -> void:
	print(wave_num)
	if left <= 0:
		next_wave()
	if $Timer.is_stopped():
		$Timer.start()

func _on_timer_timeout() -> void:
	do_wave(1, wave_file["waves"][wave_num%25])

func start_wave(rate, types):
	wave_mod = 1.07**wave_num #change this to change wave difficulty scaling (this is a exponential: 1.07^x)
	left = 0
	for type in types:
		left += types[type]
	$"../UI".update_enemy_count()
	$Timer.wait_time = rate
	$Timer.start()
	$"../UI/Wave".text = "Wave: " + str(wave_num + 1)
	$"../UI/enemies".text = "Enemies Left: " + str(left)
	

func enemy_killed():
	enemy_die.play()
	left -= 1
	$"../UI".update_enemy_count()
	

func do_wave(mod, types):
	if !$"..".leveling:
		for i in types:
			if types[i] > 0:
				spawn_enemy(i,mod)
				types[i] -= 1

func next_wave():
	$"..".leveling = true
	$"../TileMapLayer".shift_color()
	var rate = 1
	wave_num += 1
	if wave_num % 5 == 1:
		rate = 1
	if wave_num % 5 == 2:
		rate = 0.8
	if wave_num % 5 == 3:
		rate = 0.7
	if wave_num % 5 == 4:
		rate = 0.6
	if wave_num % 5 == 0 && wave_num != 0:
		rate = 0.5
		print("boss done?")
		Gamestate.player.bullet_size += 0.2
	start_wave(rate, wave_file["waves"][wave_num%25])
	
