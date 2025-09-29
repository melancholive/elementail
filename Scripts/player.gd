extends CharacterBody2D

@export var speed: float = 100.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var last_direction: Vector2 = Vector2.ZERO

func _process(delta):
	var direction = Vector2.ZERO


	# WASD or Arrow keys
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		direction.x += 1
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		direction.x -= 1
	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		direction.y += 1
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		direction.y -= 1

	# normalize so diagonal speed isn't faster
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		last_direction = direction

	velocity = direction * speed
	move_and_slide()
	
	
	if Input.is_key_pressed(KEY_SPACE):
		_play_shoot_animation(last_direction)
	elif direction != Vector2.ZERO:
		_play_walk_animation(direction)
	else:
		_play_idle_animation(last_direction)
		
func _play_shoot_animation(direction: Vector2):
	if abs(direction.x) > abs(direction.y):
		anim.play("shootright" if direction.x > 0 else "shootleft")
	else:
		anim.play("shootdown" if direction.y > 0 else "shootup")
		
func _play_walk_animation(direction: Vector2):
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			anim.play("walkright")
		else:
			anim.play("walkleft")
	else:
		if direction.y > 0:
			anim.play("walkdown")
		else:
			anim.play("walkup")
	
	
	
func _play_idle_animation(direction: Vector2):
	if abs(direction.x) > abs(direction.y):
		anim.play("idleright" if direction.x > 0 else "idle_left")
	else:
		anim.play("idledown" if direction.y > 0 else "idle_up")
