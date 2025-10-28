extends CharacterBody2D
@export var health := 30
@export var dmg := 10
@export var spd := 10
@onready var modulate0 = $AnimatedSprite2D.modulate
var acc = 20
func move():
	velocity = Vector2(170,50).rotated((Gamestate.player.global_position - global_position).angle() - PI/2)
	#position.move_toward(player.position, spd)
	#$AnimatedSprite2D.play("walk")

func damage():
	health -= Gamestate.player.dmg
	$AnimatedSprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.modulate = Color.WHITE
	if health <= 0:
		queue_free()

func _physics_process(delta: float) -> void:
	move()
	move_and_slide()


func _on_bullet_detector_body_entered(body: Node2D) -> void:
	damage()
	
	velocity -= body.velocity.rotated(PI)
	body.queue_free()
