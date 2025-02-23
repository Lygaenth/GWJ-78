extends Sprite2D
class_name Fish

@export var direction : Vector2
@export var speed : float = 20
@export var vsens : float = -1
@export var hsens : float = -1


func _process(delta):
	position  = position + speed * delta * Vector2(direction.x * hsens, direction.y * vsens).normalized()
	if (position.y < 50 || position.y > 750):
		vsens *= -1
	if (position.x < 50 || position.x > 200):
		hsens *= -1
		
	flip_h = hsens < 0
