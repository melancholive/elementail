extends Area2D

var speed = 300
var direction:Vector2 = Vector2.ZERO
	



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("projectile")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if direction != Vector2.ZERO:
		position += direction.normalized() * speed * delta


	
	
