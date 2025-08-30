extends Control

@onready var starting_scene: PackedScene = load("res://scenes/main_scene.tscn")


func _on_play_button_pressed() -> void:
  get_tree().change_scene_to_packed(starting_scene)
