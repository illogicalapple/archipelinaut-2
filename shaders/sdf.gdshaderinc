float sd_point(vec2 p) {
	return length(p);
}

float sd_circle(vec2 p, float r) {
	return length(p) - r;
}