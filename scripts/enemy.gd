extends CharacterBody2D

signal player_hit
signal killed

const SPEED = 45.0
const JUMP_VELOCITY = -250.0

@onready var kill_spot := $DeathDetector
@onready var enemy_spirte := $Sprite2D
@onready var ledge_detector := $LedgeDetector
@onready var left_side_player_detector := $LeftSidePlayerDetector
@onready var right_side_player_detector := $RightSidePlayerDetector

var direction := -1


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if kill_spot.is_colliding():
		emit_signal("killed")
		queue_free()
	
	if not ledge_detector.is_colliding():
		direction *= -1
		
	if left_side_player_detector.is_colliding():
		player_hit.emit()
	elif right_side_player_detector.is_colliding():
		player_hit.emit()
		
	if direction < 0:
		enemy_spirte.flip_h = true
	if direction > 0:
		enemy_spirte.flip_h = false
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
