extends KinematicBody2D

export var speed : float = 100
export var gravity : float = 100

var velocity = Vector2()


func _ready():
	velocity.x = speed


func _physics_process(delta):
	
	velocity.y += gravity * delta
	
	if $WallCheckRay.is_colliding():
		var collider = $WallCheckRay.get_collider()
		
		if collider.is_in_group("player"):
			collider.take_damage()
		else:
			switch_direction()
			
	elif !$GroundCheckRay.is_colliding():
		switch_direction()
	
	velocity = move_and_slide(velocity)


func switch_direction():
	velocity.x *= -1
	$WallCheckRay.cast_to.x *= -1
	$GroundCheckRay.cast_to.x *= -1
	$AnimatedSprite.flip_h = velocity.x < 0.0
