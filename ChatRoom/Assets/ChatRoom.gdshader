shader_type canvas_item;

uniform bool _isActive;
uniform sampler2D _aquarium;
uniform float maxValue = 1.0;

void vertex() {
	if(_isActive)
	{
		vec4 color = texture(_aquarium, vec2(UV.x, UV.y));
		float alpha = abs(sin(TIME + color.b * 200.0) / 8.0);
			
		COLOR = vec4(0.0, 1.0, 0.702, alpha);
	}
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
