shader_type canvas_item;

#include "res://shaders/water.gdshaderinc"
#include "res://shaders/blend.gdshaderinc"


void fragment() {
	float brightness = texture(TEXTURE, UV).r;
	if (brightness > 0.55) {
		COLOR = vec4(0.81, 0.88, 0.54, 1);
	} else {
		COLOR = vec4(1, 0.96, 0.7, 1);
	}
}