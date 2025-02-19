extends TextureRect


var _counter : float = 0

func _process(delta):
	_counter+= delta
	if delta > 0.01:
		((texture as NoiseTexture2D).noise as FastNoiseLite).seed = randi()
		_counter = 0
