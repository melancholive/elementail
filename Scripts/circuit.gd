extends Area2D

@export var is_on: bool = true

func _ready():
	_update_flamethrowers()
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("projectile"):
		toggle()

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
	for flame in get_tree().get_nodes_in_group("flamethrower"):
		var collider = flame.get_node_or_null("CollisionShape2D")
		if collider:
			collider.disabled = not is_on
