extends Area2D

@export var speed: float = 300
var direction: Vector2 = Vector2.RIGHT
var element: String

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))
	
	# Capture initial element based on starting tile
	var tilemap : TileMapLayer = get_tree().get_first_node_in_group("tilemap")
	if tilemap:
		var local_pos : Vector2 = tilemap.to_local(global_position)
		var cell : Vector2i = tilemap.local_to_map(local_pos)
		var tile_data = tilemap.get_cell_tile_data(cell)
		if tile_data:
			var tile_element = tile_data.get_custom_data("tile_element")
			if tile_element:
				element = tile_element

func _process(delta):
	if direction != Vector2.ZERO:
		position += direction.normalized() * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("mirror_left"):
		# Rotate 90° counterclockwise
		direction = Vector2(direction.y, -direction.x)
		print("Projectile hit mirror_left, new direction: ", direction)
	elif area.is_in_group("mirror_right"):
		# Rotate 90° clockwise
		direction = Vector2(direction.y, -direction.x)
		print("Projectile hit mirror_right, new direction: ", direction)
	elif area.is_in_group("circuit") and element == "grass":
		if area.has_method("toggle"):
			area.toggle()
			print("Circuit toggled by projectile")
		queue_free()
	elif (area.is_in_group("flame") or area.is_in_group("flamethrower")) and element == "grass":
		print("Projectile destroyed by flame")
		queue_free()
	elif area.is_in_group("ice_block") and element == "fire":
		print("Projectile destroyed ice block")
		#area.queue_free()
		queue_free()
