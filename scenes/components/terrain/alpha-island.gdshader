shader_type canvas_item;

void fragment() {
	COLOR = vec4(0, 0, 0, 0);
	float brightness = texture(TEXTURE, UV).r;
	if (brightness > 0.55) {
		COLOR = vec4(0.81, 0.88, 0.54, 1);
	} else if (brightness > 0.45) {
		COLOR = vec4(1, 0.96, 0.7, 0.8);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
