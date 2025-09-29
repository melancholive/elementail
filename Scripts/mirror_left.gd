extends Node2D

@export var push_speed: float = 100.0

@onready var area: Area2D = $Area2D
var push_direction: Vector2 = Vector2.ZERO

func _ready():
	area.connect("body_entered", Callable(self, "_on_body_entered"))
	area.connect("body_exited", Callable(self, "_on_body_exited"))

func _physics_process(delta: float) -> void:
	if push_direction != Vector2.ZERO:
		position += push_direction * push_speed * delta

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		var diff = global_position - body.global_position
		# choose horizontal or vertical based on which distance is larger
		if abs(diff.x) > abs(diff.y):
			push_direction = Vector2(sign(diff.x), 0)  # horizontal
		else:
			push_direction = Vector2(0, sign(diff.y))  # vertical

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		push_direction = Vector2.ZERO
