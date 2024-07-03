float sd_point(vec2 p) {
	return length(p);
}

float sd_circle(vec2 p, float r) {
	return length(p) - r;
}

float sd_box(vec2 p, vec2 b) {
	vec2 d = abs(p) - b;
	return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

float sd_onion(float d, float r) {
	return abs(d) - r;
}

float sd_round(float d, float r) {
	return d - r;
}