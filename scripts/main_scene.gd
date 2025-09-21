extends Node2D

@onready var starting_screen: PackedScene = load("res://scenes/starting_screen.tscn")
@onready var audio_player = $Player.get_node("AudioStreamPlayer2D")
@onready var biscuit_collect_sound = load("res://assets/sound/biscuit_collect.wav")
@onready var enemy_killed_sound = load("res://assets/sound/enemy_squished.wav")
@onready var player_jump_sound = load("res://assets/sound/jump.wav")
@onready var button_clicked_sound = load("res://assets/sound/button_click.wav")
@onready var back_button: Button = $Player/Camera2D/HUD/BackButton


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc_menu"):
		if back_button.visible == false:
			back_button.visible = true
		else:
			back_button.visible = false


func _on_back_button_pressed() -> void:
	audio_player.set_stream(button_clicked_sound)
	audio_player.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_packed(starting_screen)


func _on_game_won_timer_timeout() -> void:
	get_tree().change_scene_to_packed(starting_screen)


func _on_enemy_killed() -> void:
	audio_player.set_stream(enemy_killed_sound)
	audio_player.play()


func _on_audio_stream_player_2d_finished() -> void:
	audio_player.set_stream(player_jump_sound)


func _on_biscuit_player_collected(body: Node2D) -> void:
	audio_player.set_stream(biscuit_collect_sound)
	audio_player.play()
