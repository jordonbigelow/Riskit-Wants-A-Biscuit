extends CharacterBody2D


const SPEED = 70.0
const JUMP_VELOCITY = -250.0
var direction := -1

func _physics_process(delta: float) -> void:
  if not is_on_floor():
    velocity += get_gravity() * delta
  
  if $DeathDetector.is_colliding():
    print("enemy ded, breh")
    queue_free()
  
  if not $LedgeDetector.is_colliding():
    direction *= -1
    
  if $LeftSidePlayerDetector.is_colliding():
    print("You ded")    
  elif $RightSidePlayerDetector.is_colliding():
    print("You still ded")
    
  if direction < 0:
    $Sprite2D.flip_h = true
  if direction > 0:
    $Sprite2D.flip_h = false
    
  if direction:
    velocity.x = direction * SPEED
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)

  move_and_slide()
