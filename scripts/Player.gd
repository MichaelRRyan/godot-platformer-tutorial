extends KinematicBody2D

signal died
signal damage_taken

# -- Variables --

export var gravity : float = 9.8
export var jump_speed : float = 10
export var max_speed : float = 50
export var acceleration : float = 50
export var deceleration : float = 50
export var max_health : float = 4

var velocity = Vector2()
var health


func _ready():
	health = max_health


func _physics_process(delta):
	
	# Adds gravity.
	velocity.y = velocity.y + gravity * delta
	
	# Handles horizontal movement
	var left = Input.is_action_pressed("move_left")
	var right = Input.is_action_pressed("move_right")
	
	# Right movement.
	if right and not left:
		velocity.x += acceleration * delta
		$AnimatedSprite.flip_h = false
		
		if is_on_floor():
			$AnimatedSprite.play("running")		
	
	# Left movement.
	elif left and not right:
		velocity.x -= acceleration * delta
		$AnimatedSprite.flip_h = true
		
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
		
	# Handles jumping.
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_speed
		$AnimatedSprite.play("jumping")
	
	# Applies the velocity.
	velocity = move_and_slide(velocity, Vector2(0.0, -1.0))


func take_damage(knockback):
	if $DamageCooldown.time_left <= 0:
		health -= 1
		
		if health <= 0:
			emit_signal("died")
		else:
			$DamageCooldown.start()
			velocity = knockback
			emit_signal("damage_taken", health / max_health)
			

func is_falling():
	return velocity.y > 0.0


func bounce():
	velocity.y = -jump_speed * 0.8
