extends KinematicBody2D

# -- Variables --

export var gravity : float = 9.8
export var jump_speed : float = 10
export var speed : float = 50

var velocity = Vector2()


func _physics_process(delta):
	
	# Adds gravity.
	velocity.y = velocity.y + gravity * delta
	
	# Handles jumping.
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_speed
	
	# Handles horizontal movement
	var left = Input.is_action_pressed("move_left")
	var right = Input.is_action_pressed("move_right")
	
	# Right movement.
	if right and not left:
		velocity.x = speed
	
	# Left movement.
	elif left and not right:
		velocity.x = -speed
	
	# No movement.
	else:
		velocity.x = 0.0
	
	# Applies the velocity.
	velocity = move_and_slide(velocity, Vector2(0.0, -1.0))
