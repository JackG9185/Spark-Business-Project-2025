extends Camera2D

# Tweak this between 0.0 (fully on player) and 1.0 (fully on cursor)
@export var camera_bias: float = 0.3  # How much the camera leans toward the cursor

var player: Node2D

func _ready():
	# Get the player (assumes it's called "Player" and is a sibling or somewhere accessible)
	player = %stickman  # Adjust the path as needed

func _physics_process(delta):
	if not player:
		return

	# Get player position
	var player_pos = player.global_position

	# Get mouse position in world space
	var mouse_pos = get_viewport().get_camera_2d().get_global_mouse_position()

	# Interpolate between player and mouse
	var target_pos = player_pos.lerp(mouse_pos, camera_bias)

	# Set the camera position
	if !$"..".paused:
		global_position = target_pos
