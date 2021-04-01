extends Node2D


func _on_Player_died():
	if get_tree().change_scene("res://Scenes/Gameplay.tscn") != OK:
		print("Error reloading scene")
