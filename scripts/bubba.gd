extends CharacterBody3D

@export var arm1 : Node3D
@export var arm2 : Node3D

@export var camera : Camera3D
@export var sensitivity : float = 0.005

@export var SPEED : float = 5.0
@export var SPEED_SNAP : float = 100
@export var JUMP_VELOCITY = 4.5

var arm_off_pos : float

var time : float = 0

func _ready() -> void:
	camera.global_basis = global_basis
	arm_off_pos = arm1.position.y

func _process(dt: float):
	time += dt
	var arm_bob = sin(time*4)*0.01
	while time*4 > TAU:
		time -= TAU # avoid overflows
	arm1.position.y = arm_bob + arm_off_pos
	arm2.position.y = arm_bob + arm_off_pos

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate(Vector3.UP, -event.relative.x * sensitivity)
			camera.rotate_object_local(Vector3.RIGHT, -event.relative.y * sensitivity)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input := Input.get_vector("left", "right", "forward", "back")
	var direction := basis*Vector3(input.x, 0, input.y)
	var target_vel := direction*SPEED
	var res_xz_vel := Vector2(velocity.x, velocity.z).move_toward(Vector2(target_vel.x, target_vel.z), SPEED_SNAP*delta)
	velocity.x = res_xz_vel.x
	velocity.z = res_xz_vel.y

	move_and_slide()

func shoot():
	
	pass
