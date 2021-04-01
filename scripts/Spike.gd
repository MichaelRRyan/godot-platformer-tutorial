extends Area2D


func _on_Spike_body_entered(body):
	if body.is_in_group("player") && body.is_falling():
		body.take_damage(Vector2(0.0, -100.0))
