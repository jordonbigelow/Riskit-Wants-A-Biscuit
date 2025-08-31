extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -250.0
const DOUBLE_JUMP_AMOUNT = 1
var player_jump_amount = 0
var can_player_double_jump: bool = true


func _physics_process(delta: float) -> void:
  if Input.is_action_just_pressed("move_left"):
    $Sprite2D.flip_h = true
  if Input.is_action_just_pressed("move_right"):
    $Sprite2D.flip_h = false
    
  if is_on_wall() and Input.is_action_just_pressed("jump"):
    velocity.y = JUMP_VELOCITY
  
  if not is_on_floor() and Input.is_action_just_pressed("jump"):
    if player_jump_amount < DOUBLE_JUMP_AMOUNT:
      player_jump_amount += 1
      
      if can_player_double_jump:
        velocity.y = JUMP_VELOCITY  
  
  if is_on_floor():
    player_jump_amount = 0    
    
  if not is_on_floor():
    velocity += get_gravity() * delta

  if Input.is_action_just_pressed("jump") and is_on_floor():
    velocity.y = JUMP_VELOCITY
  
  var direction := Input.get_axis("move_left", "move_right")
  if direction:
    velocity.x = direction * SPEED
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)

  move_and_slide()


func _on_biscuit_tree_exiting() -> void:
  print("You collected the Biscuit!")
  $Camera2D/HUD/BackButton.visible = true
  $Camera2D/HUD/YouWinLabel.visible = true
  
  

func _on_kill_zone_body_entered(body: Node2D) -> void:
  if body.name == "Player":
    print("You Dead, bruh!")
    $RespawnTimer.start()


func _on_respawn_timer_timeout() -> void:
  queue_free()
  get_tree().reload_current_scene()


func _on_enemy_player_hit() -> void:
  print("You Dead, bruh!")
  
  if $RespawnTimer.time_left <= 0:
    $RespawnTimer.start()
