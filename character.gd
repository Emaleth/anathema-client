extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 10
@onready var camera := $SpringArm3D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity()*2 * delta

	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	get_target()
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.003)
		rotation_degrees.y = clamp(rotation_degrees.y, -180, 180)
		camera.rotate_x(-event.relative.y * 0.003)
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)

var target
func get_target():
	var potential_targets = get_tree().get_nodes_in_group("aim_assist_target")
	target = null
	var closest_target = null
	var closest_target_distance = Vector2.ZERO
	for i in potential_targets:
		if $SpringArm3D/Camera3D.is_position_in_frustum(i.global_position) && global_position.distance_to(i.global_position) < 100:
			if closest_target == null:
				closest_target = i
				closest_target_distance = $SpringArm3D/Camera3D.unproject_position(i.global_position)
			else:
				if ($SpringArm3D/Camera3D.unproject_position(i.global_position)).distance_to(get_window().size/2) < closest_target_distance.distance_to(get_window().size/2):
					closest_target = i
					closest_target_distance = $SpringArm3D/Camera3D.unproject_position(i.global_position)
	if target != closest_target:
		target = closest_target
	if target:
		$TextureRect.show()
		$TextureRect.position = closest_target_distance - Vector2(16,16)
	else:
		$TextureRect.hide()
