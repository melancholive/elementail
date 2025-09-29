extends CharacterBody2D

@export var speed: float = 100.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var last_direction: Vector2 = Vector2.ZERO
var element: String = "neutral"
var weakness: Dictionary = {"neutral":"none", "grass":"lava", "lava":"water", "water":"electric","electric":"grass"}

func _process(_delta):
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

	_update_element()
	#print("Player element:", element)

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
		anim.play("idleright" if direction.x > 0 else "idleleft")
	else:
		anim.play("idledown" if direction.y > 0 else "idleup")

func _update_element() -> void:
	var tilemap : TileMapLayer = get_tree().get_first_node_in_group("tilemap")
	if tilemap:
		var local_position: Vector2 = tilemap.to_local(global_position)
		var cell: Vector2i = tilemap.local_to_map(local_position)
		var data : TileData = tilemap.get_cell_tile_data(cell)
		var new_element : String = data.get_custom_data("tile_element")
		print(new_element)

		if data:
			if (weakness[element] == new_element ):
				get_tree().reload_current_scene()
			else:
				element = new_element
			_match_element_color()

func _match_element_color():
	var base_color = Color(1, 1, 1, 1)  # keep brightness
	
	match element:
		"lava":
			base_color = Color.from_hsv(0.05, 1.0, 1.028, 1.0)    # red
		"water":
			base_color = Color.from_hsv(0.656, 0.878, 1.898, 1.0)    # blue
		"neutral":
			base_color = Color.from_hsv(0.081, 0.749, 0.843, 1.0)   # brownish
		"electric":
			base_color = Color.from_hsv(0.992, 0.649, 2.523, 1.0)    # yellow
		_:
			base_color = Color(1, 1, 1, 1)
	
	anim.self_modulate = base_color
