extends KinematicBody2D

export var speed : float = 100
export var gravity : float = 100

var velocity = Vector2()


func _ready():
	velocity.x = speed


func _physics_process(delta):
	
	velocity.y += gravity * delta
	
	if $WallCheckRay.is_colliding() or !$GroundCheckRay.is_colliding():
		switch_direction()
	
	velocity = move_and_slide(velocity)


func switch_direction():
	velocity.x *= -1
	$WallCheckRay.cast_to.x *= -1
	$GroundCheckRay.cast_to.x *= -1
	$AnimatedSprite.flip_h = velocity.x < 0.0


func _on_AttackArea_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage()


func _on_DamageArea_body_entered(body):
	if body.is_in_group("player"):
		queue_free()
		body.bounce()
