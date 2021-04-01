extends Area2D


func _ready():
	$AnimationPlayer.play("bounce")


func _on_HealthPickup_body_entered(body):
	if body.is_in_group("player"):
		body.heal(4.0)
		queue_free()
