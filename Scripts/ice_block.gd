extends Node2D

@onready var area: Area2D = $Area2D

func _ready():
	# Connect area_entered instead of body_entered
	area.connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(other_area: Area2D) -> void:
	if other_area.is_in_group("projectile"):
		# Only react if the projectile is lava
		if other_area.element == "lava":
			print("Ice block melted by lava projectile!")
			
			# Hide the ice block
			visible = false
			
			# Disable its collision
			var collider = area.get_node_or_null("CollisionShape2D")
			if collider:
				collider.set_deferred("disabled", true)
			
			# Optionally remove the projectile
			other_area.queue_free()
