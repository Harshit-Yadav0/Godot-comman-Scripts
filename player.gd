extends CharacterBody3D

# -------- SETTINGS --------
@export var speed := 6.0
@export var jump_velocity := 5.5
@export var gravity := 18.0
@export var mouse_sensitivity := 0.15

@onready var camera = $Camera3D

var camera_rot_x := 0.0


func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event):
    if event is InputEventMouseMotion:
        rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
        
        camera_rot_x -= event.relative.y * mouse_sensitivity
        camera_rot_x = clamp(camera_rot_x, -60, 60)
        camera.rotation_degrees.x = camera_rot_x


func _physics_process(delta):
    var input_dir = Vector3.ZERO

    # WASD INPUT
    var forward = -transform.basis.z
    var right = transform.basis.x

    if Input.is_action_pressed("move_forward"):
        input_dir += forward
    if Input.is_action_pressed("move_backward"):
        input_dir -= forward
    if Input.is_action_pressed("move_left"):
        input_dir -= right
    if Input.is_action_pressed("move_right"):
        input_dir += right

    input_dir = input_dir.normalized()

    # GRAVITY
    if not is_on_floor():
        velocity.y -= gravity * delta

    # JUMP
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = jump_velocity

    # MOVE
    velocity.x = input_dir.x * speed
    velocity.z = input_dir.z * speed

    move_and_slide()
