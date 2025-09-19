extends Node2D

@onready var starting_screen: PackedScene = load("res://scenes/starting_screen.tscn")


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc_menu"):
		if $Player/Camera2D/HUD/BackButton.visible == false:
			$Player/Camera2D/HUD/BackButton.visible = true
		else:
			$Player/Camera2D/HUD/BackButton.visible = false


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_packed(starting_screen)


func _on_game_won_timer_timeout() -> void:
	get_tree().change_scene_to_packed(starting_screen)
