vec2 rot2d(vec2 v, float a) {
	return vec2(v.x * cos(a) - v.y * sin(a),
		v.x * sin(a) + v.y * cos(a));
}