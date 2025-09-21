extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -250.0
const DOUBLE_JUMP_AMOUNT = 1

var player_jump_amount = 0
var can_player_double_jump: bool = true
var kill_count: int = 0
var heart_count: int = 3

@onready var starting_scene: PackedScene = load("res://scenes/starting_screen.tscn")
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var player_sprite: Sprite2D = $Sprite2D
@onready var health_hud_component := $Camera2D/HUD/HealthComponent
@onready var respawn_timer: Timer = $RespawnTimer
@onready var kill_count_component := $Camera2D/HUD/KillCountComponent
@onready var heart_count_label := $Camera2D/HUD/HealthComponent/HeartCount
@onready var death_message: Label = $Camera2D/HUD/DeadLabel

@onready var player_won_message: Label = $Camera2D/HUD/YouWinLabel

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("move_left"):
		player_sprite.flip_h = true
	if Input.is_action_just_pressed("move_right"):
		player_sprite.flip_h = false
		
	if is_on_wall() and Input.is_action_just_pressed("jump"):
		audio_player.pitch_scale += 0.1
		audio_player.play()
		velocity.y = JUMP_VELOCITY
	
	if not is_on_floor() and Input.is_action_just_pressed("jump"):
		if player_jump_amount < DOUBLE_JUMP_AMOUNT:
			audio_player.pitch_scale = 1.5
			audio_player.play()
			player_jump_amount += 1
			
			if can_player_double_jump:
				velocity.y = JUMP_VELOCITY  
	
	if is_on_floor():
		audio_player.pitch_scale = 1.0
		player_jump_amount = 0    
		
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		audio_player.play()
		velocity.y = JUMP_VELOCITY
	
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		death_message.visible = true
		Engine.time_scale = 0.5
		respawn_timer.start()


func _on_respawn_timer_timeout() -> void:
	queue_free()
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()


func _on_enemy_player_hit() -> void:
	death_message.visible = true
	
	if heart_count > 0:
		heart_count -= 1
		health_hud_component.get_child(heart_count).hide()
		heart_count_label.text = " x " + str(heart_count)
	
	if heart_count <= 0:
		if respawn_timer.time_left <= 0:
			Engine.time_scale = 0.25
			respawn_timer.start()


func _on_enemy_killed() -> void:
	kill_count += 1
	kill_count_component.get_child(1).text = " x " + str(kill_count)


func _on_biscuit_player_collected(_body: Node2D) -> void:
	player_won_message.visible = true
