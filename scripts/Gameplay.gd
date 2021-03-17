extends Node2D


func _on_Player_died():
	get_tree().change_scene("res://Scenes/Gameplay.tscn")
