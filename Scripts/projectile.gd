extends Node2D

@export var speed: float = 300
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	add_to_group("projectile")
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta: float) -> void:
	if direction != Vector2.ZERO:
		global_position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("circuit"):
		area.call("toggle")
		queue_free()

func _on_body_entered(body: Node) -> void:
	# Mirrors are CharacterBody2D or Node2D with collision
	if body.is_in_group("mirror"):
		# Optionally do something, like bounce or destroy projectile
		queue_free()
