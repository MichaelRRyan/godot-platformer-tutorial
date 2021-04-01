extends KinematicBody2D

export var speed : float = 100
export var gravity : float = 100

var velocity = Vector2()


func _ready():
	velocity.x = speed
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	for enemy in enemies:
		$WallCheckRay.add_exception(enemy)


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
		var direction = (body.position - position).normalized()
		var knockback = Vector2(direction.x * 50, -50)
		
		body.take_damage(knockback)


func _on_DamageArea_body_entered(body):
	if body.is_in_group("player"):
		queue_free()
		body.bounce()
