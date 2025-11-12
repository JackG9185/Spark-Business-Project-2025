extends CharacterBody2D
@export var SPEED = 400

var dir : float
var spawnPos : Vector2
var spawnRot : float

func _ready() -> void:
	global_position = spawnPos
	global_rotation = spawnRot
	
func _physics_process(delta: float) -> void:
	velocity = Vector2(0,-SPEED).rotated(dir)
	move_and_slide()


func _on_life_timeout() -> void: #DIE!!!!
	queue_free()
