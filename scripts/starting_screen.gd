extends Control

@onready var starting_scene: PackedScene = load("res://scenes/main_scene.tscn")
@onready var guide_scene: PackedScene = load("res://scenes/guide_screen.tscn")

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(starting_scene)


func _on_settings_button_pressed() -> void:
	pass


func _on_guide_button_pressed() -> void:
	get_tree().change_scene_to_packed(guide_scene)
