extends Area2D

var speed: float = 300
var direction: Vector2 = Vector2.RIGHT

var element : String

func _process(delta):
	if direction != Vector2.ZERO:
		position += direction.normalized() * speed * delta

	# Assign element based on the tile it is standing on
	var tilemap : TileMapLayer = get_tree().get_first_node_in_group("tilemap")
	if tilemap:
		var local_pos : Vector2 = tilemap.to_local(global_position)
		var cell : Vector2i = tilemap.local_to_map(local_pos)
		var tile_data = tilemap.get_cell_tile_data(cell)
		if tile_data:
			var tile_element = tile_data.get_custom_data("tile_element")
			if tile_element:
				element = tile_element

func _on_area_entered(area: Area2D):
	if area.is_in_group("mirror_left"):
		# Rotate 90° counterclockwise (left)
		direction = Vector2(-direction.y, direction.x)
	elif area.is_in_group("mirror_right"):
		# Rotate 90° clockwise (right)
		direction = Vector2(direction.y, -direction.x)
	elif area.is_in_group("circuit"):
		# Trigger circuit logic
		area.toggle()
		queue_free()  # destroy projectile
	elif (area.is_in_group("flame") or area.is_in_group("flamethrower")) and element == "grass":
		print("Projectile hit flame/flamethrower")
		queue_free()
