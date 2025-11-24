extends CharacterBody2D
@export var health := 70.0
@export var dmg := 10.0
@export var spd := 220.0
var mod = 1
var acc = 20

func _ready() -> void:
	health *= mod
	dmg *= mod
	spd *= mod

func move():
	velocity = velocity.move_toward((Gamestate.player.global_position - global_position).normalized() * spd,acc)
	#position.move_toward(player.position, spd)
	$AnimatedSprite2D.play("walk")

func damage():
	self.health -= Gamestate.player.dmg
	$AnimatedSprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.modulate = Color.WHITE
	if health <= 0:
		Gamestate.spawner.enemy_killed()
		queue_free()

func _physics_process(delta: float) -> void:
	move()
	move_and_slide()


func _on_bullet_detector_body_entered(body: Node2D) -> void:
	damage()
	
	velocity -= body.velocity.rotated(PI)
	body.queue_free()
