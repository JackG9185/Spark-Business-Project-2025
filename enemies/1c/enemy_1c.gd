extends CharacterBody2D
@export var health := 70.0
@export var dmg := 10.0
@export var spd := 220.0
var mod = 1.0
var acc = 20
@onready var og_color = $AnimatedSprite2D.get_instance_shader_parameter("shader_parameter/new_color")
func _ready() -> void:
	health *= mod
	dmg *= mod
	spd *= mod

func move():
	velocity = velocity.move_toward((Gamestate.player.global_position - global_position).normalized() * spd,acc)
	#position.move_toward(player.position, spd)
	$AnimatedSprite2D.play("walk")
var dead = false
func damage():
	
	$Enemy.play()
	self.health -= Gamestate.player.dmg
	if health <= 0:
		if !dead:
			Gamestate.spawner.enemy_killed()
			queue_free()
			dead = true
	$AnimatedSprite2D.set_instance_shader_parameter("shader_parameter/new_color", Color.RED)
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.set_instance_shader_parameter("shader_parameter/new_color", og_color)
	

func _physics_process(delta: float) -> void:
	move()
	move_and_slide()


func _on_bullet_detector_body_entered(body: Node2D) -> void:
	damage()
	
	velocity -= body.velocity.rotated(PI)
	body.queue_free()
