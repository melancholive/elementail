extends Node2D

@export var speed: float = 100.0

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

	position += direction * speed * delta
