shader_type canvas_item;

void fragment() {
	float brightness = texture(TEXTURE, UV).r;
	if (brightness > 0.55) {
		COLOR = vec4(0.81, 0.88, 0.54, 1);
	} else if (brightness > 0.45) {
		COLOR = vec4(1, 0.96, 0.7, 1);
	} else if (brightness > 0.35 + (sin(TIME * 1.5) / 50.0)) {
		COLOR = vec4(0.44, 0.75, 0.87, 1);
	} else {
		COLOR = vec4(0.44, 0.75, 0.87, 0);
	}
	
}