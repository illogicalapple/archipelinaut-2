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

vec2 scale(vec2 v, vec2 s) {
	return v * s;
}

vec2 translate_uv(vec2 v, vec2 p) {
	return v - p;
}

vec2 rot2d_uv(vec2 v, float a) {
	return rot2d(v, -a);
}

vec2 rot2d_about_uv(vec2 v, vec2 p, float a) {
	return translate_uv(rot2d_uv(translate_uv(v, p), a), -p);
}

vec2 scale_uv(vec2 v, vec2 s) {
	return v / s;
}