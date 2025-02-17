shader_type canvas_item;

uniform sampler2D _aquarium;

void vertex() {
	vec4 color = texture(_aquarium, vec2(UV.x, UV.y));
	COLOR = vec4(0.0, 1.0, 0.702, abs(sin(TIME + color.b * 200.0)) * 0.7);
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
