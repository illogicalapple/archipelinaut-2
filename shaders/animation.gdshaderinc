float anim_linear(float t, float st, float et, float s, float e) {
	return mix(s, e, (t - st) / (et - st)) * float(t > st && t <= et);
}

float anim_ease(float t, float st, float et, float s, float e) {
	return mix(s, e, smoothstep(0, 1, (t - st) / (et - st))) * float(t > st && t <= et);
}