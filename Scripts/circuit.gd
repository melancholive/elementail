extends Area2D

@export var is_on: bool = true

func _ready():
	_update_flamethrowers()
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("projectile"):
		toggle()
		area.queue_free()

func toggle():
	is_on = not is_on
	_update_flamethrowers()

func _update_flamethrowers():
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
				# Shrink lifetime to almost zero to clear all active particles
				particles.lifetime = 0.01
				particles.restart()
		else:
			print(" - No CPUParticles2D found under", flame_node.name)

	# toggle colliders
	for flamethrower in get_tree().get_nodes_in_group("flamethrower"):
		# Toggle the collider shape
		var collider = flamethrower.get_node_or_null("CollisionShape2D")
		if collider:
			collider.disabled = not is_on

		# Disable the Area2D itself so it stops detecting bodies
		flamethrower.monitoring = is_on
