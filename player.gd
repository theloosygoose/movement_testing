extends Area2D 


@export var speed:int = 100
@export var friction:float = 1.5

@export var dash_frames_max: int = 8

var max_speed:float = 1011 

var prev_velocity: Vector2 
var prev_magnitute: float

var dash_frame_counter: int

@onready var shader:ShaderMaterial = material

func _init() -> void:
	print("MAX SPEED" + str(max_speed))

func _physics_process(delta: float) -> void:
	var new_velocity: Vector2 = Vector2.ZERO
	var new_magnitude: float

	#check for actions
	check_action()
	#get direction 
	new_velocity = get_direction()
	#add speed
	new_velocity = new_velocity * speed 
	
	#add previous (excess) velocity to new_velocity
	new_velocity += prev_velocity / friction

	#add dash if happen
	new_velocity = calculate_dash(new_velocity)
	#Find length of vector 
	new_velocity = accellaration(prev_magnitute, new_velocity)

	position += new_velocity * delta

	new_magnitude = new_velocity.length()

	apply_speed_shader(new_magnitude)

	#If player is basically stopped just make player freeze
	
	#send values to next frame
	prev_velocity = new_velocity 
	print(new_velocity)
	prev_magnitute = new_magnitude
		

func calculate_dash(velocity: Vector2) -> Vector2:
	if dash_frame_counter >= dash_frames_max:
		dash_frame_counter = 0

	elif dash_frame_counter > 0:
		velocity = velocity * 1.4
		dash_frame_counter += 1
		
	return velocity

func apply_speed_shader(magnitude:float) -> void:
	if magnitude >= max_speed + 1:
		shader.set_shader_parameter("make_white", true)
	else:
		shader.set_shader_parameter("make_white", false)
		
func get_direction() -> Vector2:
	var direction:Vector2 = Vector2.ZERO

	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	
	return direction.normalized()
	
func check_action() -> void:
	if Input.is_action_just_pressed("shoot_primary"):
		dash_frame_counter = 1 
	
func accellaration(prev_mag: float, new_velocity: Vector2) -> Vector2:
	if prev_mag > new_velocity.length():
		new_velocity = new_velocity / 1.2

	if new_velocity.length() <= float(speed)/4:
		return Vector2.ZERO
	else:
		return new_velocity
