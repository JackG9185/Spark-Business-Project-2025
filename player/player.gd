extends CharacterBody2D
#defining all the variables n stuff
var max_hp :=100
var health := max_hp
var input_vector
var speed = 200
const FRICTION = 100
var acc = 80
var mouse_pos : Vector2
var angle_to_mouse : float
var state = state_enum.move
var dmg := 10
var sht_spd = 3

#define nodes on ready so they load in time
@onready var inv_timer = $invulnerablility
@onready var dash_cooldown = $dash_cooldown
@onready var proj = load("res://bullet.tscn")
@onready var main = get_tree().root
@onready var animator = $AnimatedSprite2D
@onready var gun_sprite = $Gun
@onready var shot_timer = $shoot_timer
#state machine to execute certain functions when the player is in a matching state
enum state_enum {
	move,
	dead,
}

func _ready() -> void:
	pass

func get_input_vector(): #custom script for essentially getting WASD in all directions, also adds controller support
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("input_right") - Input.get_action_strength("input_left") 
	input_vector.y = Input.get_action_strength("input_down") - Input.get_action_strength("input_up")
	input_vector = input_vector.normalized()

func do_movement():
	if input_vector != Vector2.ZERO: #if the player IS moving apply velocity
		velocity = velocity.move_toward(input_vector * speed, acc)
	else: #if the player is NOT moving apply friction
		velocity = velocity.move_toward(Vector2(0,0),FRICTION)
	move_and_slide()

func shoot():
	if shot_timer.is_stopped() == true:
		var instance = proj.instantiate()
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
		inv_timer.start(inv) #do i-frames
		health -= dmg
		velocity += source_vel.normalized() * 1500 #knockback

func dash():
	if inv_timer.time_left < 0.2:
		inv_timer.start(0.2)
	dash_cooldown.start(1)
	velocity = input_vector * 2000

func do_debug_col(): #displays when the player is invulnerable
	if inv_timer.is_stopped():
		$CollisionShape2D.debug_color = Color("MEDIUM_SLATE_BLUE", 0.41)
	else:
		$CollisionShape2D.debug_color = Color("CHARTREUSE", 0.41)

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
	do_movement()
	if Input.is_action_pressed("fire"):
		shoot()
	if Input.is_action_just_pressed("dash") and dash_cooldown.is_stopped():
		dash()

func dead():
	pass

func update_stats(hp,sp,dm,ss):
	max_hp = hp
	speed = sp
	dmg = dm
	sht_spd = ss
	shot_timer.wait_time = 1.0/sht_spd

func _physics_process(delta: float) -> void:
	get_input_vector()
	get_mouse()
	do_debug_col()
	play_anims()
	update_stats(100, 200, 10, 3)
	match state: #matches a function to each state and runs it.
		state_enum.move:
			move()
		state_enum.dead:
			dead()


func _on_hitbox_body_entered(body: Node2D) -> void:
	take_damage(body.dmg,0.4,body.velocity)
	
