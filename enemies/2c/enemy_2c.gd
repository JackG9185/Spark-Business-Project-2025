extends CharacterBody2D
@export var health := 50.0
@export var dmg := 35.0
@export var spd := 20.0
@onready var modulate0 = $AnimatedSprite2D.modulate
var mod = 1
var acc = 20

func _ready() -> void:
	health *= mod
	dmg *= mod
	spd *= mod
	

func move():
	velocity = Vector2(170,50).rotated((Gamestate.player.global_position - global_position).angle() - PI/2)
	#position.move_toward(player.position, spd)
	#$AnimatedSprite2D.play("walk")
var dead = false
func damage():
	$Enemy.play()
	health -= Gamestate.player.dmg
	if health <= 0:
		if !dead:
			Gamestate.spawner.enemy_killed()
			queue_free()
			dead = true
	$AnimatedSprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.modulate = Color.WHITE
	

func _physics_process(delta: float) -> void:
	move()
	move_and_slide()


func _on_bullet_detector_body_entered(body: Node2D) -> void:
	damage()
	
	velocity -= (body.velocity).rotated(PI)
	body.queue_free()
