extends Control

@onready var starting_scene: PackedScene = load("res://scenes/main_scene.tscn")
@onready var guide_scene: PackedScene = load("res://scenes/guide_screen.tscn")
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _on_play_button_pressed() -> void:
	audio_player.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_packed(starting_scene)


func _on_settings_button_pressed() -> void:
	pass


func _on_guide_button_pressed() -> void:
	audio_player.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_packed(guide_scene)
