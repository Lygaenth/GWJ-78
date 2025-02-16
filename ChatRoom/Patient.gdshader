shader_type canvas_item;
uniform bool isBugged;
uniform sampler2D Texture;

void fragment() {
	if(isBugged && COLOR.a == 1.0)
		COLOR = texture(Texture, UV);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
