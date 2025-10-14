extends CharacterBody2D
@export var health := 100
@export var dmg := 10
@export var spd := 10
@onready var player = %stickman
var acc = 20
func move():
	velocity = velocity.move_toward((player.global_position - global_position).normalized() * spd,acc)
	#position.move_toward(player.position, spd)

func damage():
	health -= player.dmg
	if health <= 0:
		queue_free()

func _physics_process(delta: float) -> void:
	move()
	print(health)
	move_and_slide()


func _on_bullet_detector_body_entered(body: Node2D) -> void:
	damage()
	
	velocity -= body.velocity.rotated(PI)
	body.queue_free()
