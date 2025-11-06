extends Node2D
@onready var enemy1 = load("res://enemy.tscn")
@onready var enemy2 = load("res://enemy2.tscn")
@onready var main = get_tree().current_scene
var wave_num = 0
var n = 0
var canSpawn := false
const range = 300
var wave1 = {
	"enemy": 10,
	"enemy2": 4
}
func _ready() -> void:
	start_wave(1, wave1)

func spawn_enemy(type, mod):
	if type == "enemy":
		var instance = enemy1.instantiate()
		instance.global_position = %stickman.global_position + Vector2(randi_range(-range,range),randi_range(-range,range))
		#%stickman.global_position = instance.global_position
		main.add_child.call_deferred(instance)
		print(instance.global_position)
	if type == "enemy2":
		var instance = enemy2.instantiate()
		instance.global_position = %stickman.global_position + Vector2(randi_range(-range/2,range/2),randi_range(-range/2,range/2))
		#%stickman.global_position = instance.global_position
		main.add_child.call_deferred(instance)
		print(instance.global_position)

func _physics_process(delta: float) -> void:
	if $Timer.is_stopped():
		print("ADIHASLJDKJSAHNKADS")
		$Timer.start()

func _on_timer_timeout() -> void:
	do_wave(1, wave1)
	if canSpawn:
		n -= 1
		spawn_enemy("enemy2",1)

func start_wave(rate, types):
	wave_num += 1
	$Timer.wait_time = rate
	$Timer.start()
	$"../UI/Wave".text = "Wave: " + str(wave_num)

func do_wave(mod, types):
	for i in wave1:
		if wave1[i] > 0:
			spawn_enemy(i,1)
			wave1[i] -= 1
