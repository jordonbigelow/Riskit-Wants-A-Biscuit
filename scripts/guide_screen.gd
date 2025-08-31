extends Control

@onready var starting_scene: PackedScene = load("res://scenes/starting_screen.tscn")

func _on_back_button_pressed() -> void:
  get_tree().change_scene_to_packed(starting_scene)
