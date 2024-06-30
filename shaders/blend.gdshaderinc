vec4 blend_mix(vec4 top, vec4 base) {
	base = mix(base, top, top.a);
	return base;
}

vec4 blend_add(vec4 a, vec4 b) {
	return clamp(a * a.a + b * b.a, vec4(0), vec4(1));
}

vec4 blend_union(vec4 a, vec4 b) {
	a.a = a.a * b.a;
	b.a = a.a;
	return blend_add(a, b);
}