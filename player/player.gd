extends CharacterBody2D
#defining all the variables n stuff
var max_hp := 100
var health := max_hp
var input_vector
var speed = 200
const FRICTION = 100
var acc = 80
var mouse_pos : Vector2
var angle_to_mouse : float
var state = state_enum.move
var dmg := 50
var sht_spd = 3


#define nodes on ready so they load in time
@onready var shootSound: AudioStreamPlayer = $Shoot
@onready var step: AudioStreamPlayer = $Step
@onready var inv_timer = $invulnerablility
@onready var dash_cooldown = $dash_cooldown
@onready var proj = load("res://player/bullet/bullet.tscn")
@onready var main = get_tree().current_scene
@onready var animator = $AnimatedSprite2D
@onready var gun_sprite = $Gun
@onready var shot_timer = $shoot_timer
@onready var reticle: CompressedTexture2D = preload("res://player/ReticleResize2.png")

#state machine to execute certain functions when the player is in a matching state
enum state_enum {
	move,
	dead,
}

func _ready() -> void:
	shot_timer.wait_time = 1.0/sht_spd
	Gamestate.player = self
	Input.set_custom_mouse_cursor(reticle)

func get_input_vector(): #custom script for essentially getting WASD in all directions, also adds controller support
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("input_right") - Input.get_action_strength("input_left") 
	input_vector.y = Input.get_action_strength("input_down") - Input.get_action_strength("input_up")
	input_vector = input_vector.normalized()

func do_movement():
	#print(input_vector * speed)
	if input_vector != Vector2.ZERO: #if the player IS moving apply velocity
		velocity = velocity.move_toward(input_vector * speed, acc)
	else: #if the player is NOT moving apply friction
		velocity = velocity.move_toward(Vector2(0,0),FRICTION)
	move_and_slide()
var bullet_size = 1.0
func shoot():
	if !$"..".paused:
		if shot_timer.is_stopped() == true:
			shootSound.play()
			var instance = proj.instantiate()
			instance.scale = Vector2(bullet_size, bullet_size)
			instance.dir = angle_to_mouse
			instance.spawnPos = global_position + Vector2(0,-40).rotated(angle_to_mouse)+Vector2(0,-abs(5*sin(angle_to_mouse)))
			instance.spawnRot = angle_to_mouse
			main.add_child.call_deferred(instance)
			shot_timer.start()

	
func get_mouse():
	mouse_pos = get_global_mouse_position()
	angle_to_mouse = (global_position - mouse_pos).angle() - PI/2

func take_damage(dmg, inv, source_vel):
	
	if inv_timer.is_stopped():
		$Ouch.play()
		inv_timer.start(inv) #do i-frames
		health -= dmg
		velocity += source_vel.normalized() * 1500 #knockback
		$AnimatedSprite2D.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		$AnimatedSprite2D.modulate = Color.WHITE
		
		$"../UI".update_ui("hp",health)
		$"../UI".update_health(health, max_hp)
	if health <= 0:
		state = state_enum.dead

func dash():
	if inv_timer.time_left < 0.2:
		inv_timer.start(0.2)
	dash_cooldown.start(1)
	velocity = input_vector * (1600)
	Gamestate.ui.start_dash()

func do_debug_col(): #displays when the player is invulnerable
	if inv_timer.is_stopped():
		$CollisionShape2D.debug_color = Color("MEDIUM_SLATE_BLUE", 0.41)
	else:
		$CollisionShape2D.debug_color = Color("CHARTREUSE", 0.41)
var done = false
func play_anims():
	animator.flip_h = mouse_pos.x < global_position.x
	if input_vector != Vector2.ZERO:
		animator.play("walk")
	else:
		animator.play("stand")
	
	if mouse_pos.x < global_position.x:
		gun_sprite.rotation = angle_to_mouse - PI/2
		gun_sprite.flip_v = true
	else:
		gun_sprite.rotation = angle_to_mouse - PI/2
		gun_sprite.flip_v = false
	
func move():
	play_anims()
	do_movement()
	get_mouse()
	if Input.is_action_pressed("fire"):
		shoot()
	if Input.is_action_just_pressed("dash") and dash_cooldown.is_stopped():
		dash()

func dead():
	if velocity.x != 0:
		if sign(velocity.x) == -1:
			animator.flip_h = true
			animator.rotation = 80
			$Gun.rotation = 80
			$Gun.flip_v = true
		else:
			animator.flip_h = false
			animator.rotation = -80
			$Gun.rotation = -80
			$Gun.flip_v = false
	$AnimatedSprite2D.play("stand")
	$"../UI/death_screen".position.y = lerp($"../UI/death_screen".position.y,143.0,0.05)


func update_stats(hp,sp,dm,ss):
	print("UPDATED")
	max_hp = hp
	speed = sp
	dmg = dm
	sht_spd = ss
	shot_timer.wait_time = 1.0/sht_spd
	
	$"../UI".update_health(health, max_hp)
	$"../UI".update_ui("hp",health)

var stepped = false
func _physics_process(delta: float) -> void:
	$"../UI".update_ui("hp",health)
	if animator.animation == "walk":
		if animator.frame % 2 == 1:
			stepped = true
		elif stepped:
			step.play()
			stepped = false
	get_input_vector()
	do_debug_col()
	#update_stats(100, 200, dmg, 3)
	match state: #matches a function to each state and runs it.
		state_enum.move:
			move()
		state_enum.dead:
			dead()


func _on_hitbox_body_entered(body: Node2D) -> void:
	take_damage(body.dmg,0.4,body.velocity)
	
