extends CharacterBody3D
#totally orginal and not copied code to be fair I did modify it for are own purposes
@export var movement_speed: float = 2.0
@export var target: CharacterBody3D
var movement_target_position: Vector3 
@onready var navigation_agent: NavigationAgent3D = $RigidBody3D/NavigationAgent3D

func _ready():
	
	navigation_agent.path_desired_distance = 5.0
	navigation_agent.target_desired_distance = 5.0

	
	actor_setup.call_deferred()

func _process(delta):
	movement_target_position=target.global_position
func actor_setup():
	
	await get_tree().physics_frame
	set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		navigation_agent.target_position=target.global_position

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	if self.global_position.distance_to(target.global_position)>1.1:
		
		velocity = current_agent_position.direction_to(next_path_position) * movement_speed
		move_and_slide()
