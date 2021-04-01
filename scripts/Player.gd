extends KinematicBody2D

signal died
signal health_changed

# -- Exported Variables --

export(float) var gravity = 9.8
export(float) var jump_speed = 10
export(float) var max_speed = 50
export(float) var acceleration = 50
export(float) var deceleration = 50
export(float) var max_health = 4
export(int) var max_jumps = 2

# -- Regular Variables --

var velocity = Vector2()
var health
var jumps = 0


func _ready():
	health = max_health


func _physics_process(delta):
	
	# Adds gravity.
	velocity.y = velocity.y + gravity * delta
	
	handle_movement(delta)
	handle_jumping()
	
	# Applies the velocity.
	velocity = move_and_slide(velocity, Vector2.UP)


func handle_movement(delta):
	
	var input = Input.get_action_strength("move_right")
	input -= Input.get_action_strength("move_left")
	
	# Movement.
	if input != 0.0:
		velocity.x += acceleration * input * delta
		$AnimatedSprite.flip_h = input < 0
		
		if is_on_floor():
			$AnimatedSprite.play("running")			
	
	# No movement.
	else:
		velocity.x -= min(deceleration * delta, abs(velocity.x)) * sign(velocity.x)
		
		if is_on_floor():
			$AnimatedSprite.play("idle")
	
	# Clamps the movement to a max speed.
	if abs(velocity.x) > max_speed:
		velocity.x = max_speed * sign(velocity.x)


func handle_jumping():
	
	# Reset jumps.
	if jumps > 0 and is_on_floor():
		jumps = 0
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or jumps < max_jumps:
			velocity.y = -jump_speed
			$AnimatedSprite.play("jumping")
			jumps += 1


func take_damage(knockback):
	if $DamageCooldown.time_left <= 0:
		health -= 1
		
		if health <= 0:
			emit_signal("died")
		else:
			$DamageCooldown.start()
			velocity = knockback
			emit_signal("health_changed", health / max_health)
			

func is_falling():
	return velocity.y > 0.0


func bounce():
	velocity.y = -jump_speed * 0.8


func heal(amount):
	health = min(health + amount, max_health)
	emit_signal("health_changed", health / max_health)
