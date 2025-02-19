shader_type canvas_item;

float random(vec2 uv) {
    return fract(tan(uv.x * 2.8 * uv.y * TIME / 10.0));
}

void fragment() {
	float value = random(UV);
	if ((sqrt(pow((UV.x - 0.2) * (UV.y - 1.0), 2))) < 0.0030)
	{
		if (abs(value) > 0.95)
			COLOR = vec4(0.0, 0.0, 0.0, 1.0);
			
		if (abs(value) < 0.05)
			COLOR = vec4(1.0, 1.0, 1.0, 1.0);
	}
}



