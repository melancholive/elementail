extends Node


func _on_start_button_pressed() -> void:
	print("Button pressed!")
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")
