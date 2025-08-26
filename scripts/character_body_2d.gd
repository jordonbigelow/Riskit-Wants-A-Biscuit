extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -250.0


func _physics_process(delta: float) -> void:
  if Input.is_action_just_pressed("move_left"):
    $Sprite2D.flip_h = true
  if Input.is_action_just_pressed("move_right"):
    $Sprite2D.flip_h = false
    
  # Add the gravity.
  if not is_on_floor():
    velocity += get_gravity() * delta

  # Handle jump.
  if Input.is_action_just_pressed("jump") and is_on_floor():
    velocity.y = JUMP_VELOCITY
  
  # Get the input direction and handle the movement/deceleration.
  # As good practice, you should replace UI actions with custom gameplay actions.
  var direction := Input.get_axis("move_left", "move_right")
  if direction:
    velocity.x = direction * SPEED
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)

  move_and_slide()


# This is running when the scene is reloaded,
# this will cause issues
# Perhaps find a different signal to use???
func _on_biscuit_tree_exiting() -> void:
  print("You collected the Biscuit!")

func _on_kill_zone_body_entered(body: Node2D) -> void:
  print("You Dead, bruh!")
  $RespawnTimer.start()


func _on_respawn_timer_timeout() -> void:
  print("Timer Expired")
  queue_free()
  get_tree().reload_current_scene()
