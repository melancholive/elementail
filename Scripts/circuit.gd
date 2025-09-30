extends Area2D

@export var is_on: bool = true

signal toggled

func _ready():
	_update_flamethrowers()
	_update_dependents()
	connect("area_entered", Callable(self, "_on_area_entered"))

func get_is_on() -> bool:
	return is_on

func toggle():
	is_on = not is_on
	_update_flamethrowers()
	_update_dependents()
	_update_color()
	emit_signal("toggled")

func _update_flamethrowers():
	# --- Handle flames
	for flame_node in get_tree().get_nodes_in_group("flame"):
		var particles = flame_node.get_node_or_null("CPUParticles2D")
		if particles:
			if not particles.has_meta("original_lifetime"):
				particles.set_meta("original_lifetime", particles.lifetime)

			if is_on:
				print(" - Turning particles ON")
				particles.lifetime = particles.get_meta("original_lifetime")
				particles.emitting = true
				particles.restart()
			else:
				print(" - Turning particles OFF")
				particles.emitting = false
				particles.lifetime = 0.01
				particles.restart()
		else:
			print(" - No CPUParticles2D found under", flame_node.name)

	# --- Handle flamethrower colliders
	for flamethrower in get_tree().get_nodes_in_group("flamethrower"):
		var collider = flamethrower.get_node_or_null("CollisionShape2D")
		if collider:
			collider.set_deferred("disabled", not is_on)  # safer than immediate change
		flamethrower.set_deferred("monitoring", is_on)

func _update_dependents():
	for node in get_tree().get_nodes_in_group("electric_dependent"):
		# Hide or show the node
		if node is CanvasItem:  # Sprite2D, Node2D, etc.
			node.visible = is_on

		# Disable collision shapes if they exist
		var collider = node.get_node_or_null("CollisionShape2D")
		if collider:
			collider.set_deferred("disabled", not is_on)

		# If node itself is an Area2D/PhysicsBody2D
		if node.has_method("set_deferred"):
			node.set_deferred("monitoring", is_on)

func _update_color():
	var sprite = get_node_or_null("Sprite2D")
	if sprite:
		if is_on:
			sprite.self_modulate = Color(1, 1, 1)   # normal (white = no tint)
		else:
			sprite.self_modulate = Color(0, 1, 0)   # green when off
