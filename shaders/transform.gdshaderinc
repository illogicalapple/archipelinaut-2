vec2 rot2d(vec2 v, float a) {
	return vec2(v.x * cos(a) - v.y * sin(a),
		v.x * sin(a) + v.y * cos(a));
}

vec2 mirror(vec2 v, vec2 mirror, vec2 pos) {
	v -= pos;
	v *= mirror;
	v += pos;
	return v;
}

vec2 translate(vec2 v, vec2 p) {
	return v + p;
}