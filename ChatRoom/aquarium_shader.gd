extends PanelContainer
class_name Aquarium

var counter : float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	return
	
	counter += delta
	if (counter > 0.15):
		var aquarium : NoiseTexture2D = (material as ShaderMaterial).get_shader_parameter("_aquarium")
		(aquarium.noise as FastNoiseLite).seed = randi()
		counter = 0
