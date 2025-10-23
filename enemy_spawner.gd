extends Node2D
@onready var enemy1 = load("res://enemy.tscn")
@onready var main = get_tree().current_scene

func _ready() -> void:
	$Timer.start()

func spawn_enemy(type, mod):
	if type == "enemy":
		var instance = enemy1.instantiate()
		instance.global_position = %stickman.global_position + Vector2(randi_range(-1000,1000),randi_range(-1000,1000))
		#%stickman.global_position = instance.global_position
		main.add_child.call_deferred(instance)
		print(instance.global_position)

func _physics_process(delta: float) -> void:
	if $Timer.is_stopped():
		print("ADIHASLJDKJSAHNKADS")
		$Timer.start()

func _on_timer_timeout() -> void:
	spawn_enemy("enemy",1)
