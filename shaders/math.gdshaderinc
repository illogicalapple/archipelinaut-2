float map(float x, float in_min, float in_max, float out_min, float out_max) {
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

vec2 map2(vec2 x, vec2 in_min, vec2 in_max, vec2 out_min, vec2 out_max) {
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

vec3 map3(vec3 x, vec3 in_min, vec3 in_max, vec3 out_min, vec3 out_max) {
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

vec4 map4(vec4 x, vec4 in_min, vec4 in_max, vec4 out_min, vec4 out_max) {
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}