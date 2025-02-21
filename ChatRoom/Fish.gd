extends Sprite2D
class_name Fish

var speed : float = 20
@export var direction : Vector2
var sens : float = -1

func _process(delta):
	position  = position + sens * speed * delta * direction.normalized()
	if (position.y < 200 || position.y > 800):
		sens *= -1

	flip_h = sens > 0
