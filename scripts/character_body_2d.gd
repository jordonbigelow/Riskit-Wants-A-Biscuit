extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -250.0
const DOUBLE_JUMP_AMOUNT = 1

var player_jump_amount = 0
var can_player_double_jump: bool = true
var kill_count: int = 0
var heart_count: int = 3

@onready var starting_scene: PackedScene = load("res://scenes/starting_screen.tscn")


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("move_left"):
		$Sprite2D.flip_h = true
	if Input.is_action_just_pressed("move_right"):
		$Sprite2D.flip_h = false
		
	if is_on_wall() and Input.is_action_just_pressed("jump"):
		$AudioStreamPlayer2D.pitch_scale += 0.1
		$AudioStreamPlayer2D.play()
		velocity.y = JUMP_VELOCITY
	
	if not is_on_floor() and Input.is_action_just_pressed("jump"):
		if player_jump_amount < DOUBLE_JUMP_AMOUNT:
			$AudioStreamPlayer2D.pitch_scale = 1.5
			$AudioStreamPlayer2D.play()
			player_jump_amount += 1
			
			if can_player_double_jump:
				velocity.y = JUMP_VELOCITY  
	
	if is_on_floor():
		$AudioStreamPlayer2D.pitch_scale = 1.0
		player_jump_amount = 0    
		
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		$AudioStreamPlayer2D.play()
		velocity.y = JUMP_VELOCITY
	
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_biscuit_tree_exiting() -> void:
	$Camera2D/HUD/YouWinLabel.visible = true
	$GameWonTimer.start()


func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$Camera2D/HUD/DeadLabel.visible = true
		Engine.time_scale = 0.5
		$RespawnTimer.start()


func _on_respawn_timer_timeout() -> void:
	queue_free()
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()


func _on_enemy_player_hit() -> void:
	$Camera2D/HUD/DeadLabel.visible = true
	if heart_count > 0:
		heart_count -= 1
		$Camera2D/HUD/HealthComponent/HeartIcon.hide()
		$Camera2D/HUD/HealthComponent/HeartCount.text = " x " + str(heart_count)
	
	if heart_count <= 0:
		if $RespawnTimer.time_left <= 0:
			Engine.time_scale = 0.25
			$RespawnTimer.start()


func _on_enemy_killed() -> void:
	kill_count += 1
	$Camera2D/HUD/KillCountComponent/KillCount.text = " x " + str(kill_count)
