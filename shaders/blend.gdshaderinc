vec4 blend_mix(vec4 top, vec4 base) {
	return vec4(mix(base.rgb, top.rgb, top.a), clamp(top.a + base.a, 0, 1));
}

vec4 blend_add(vec4 a, vec4 b) {
	return clamp(vec4(vec3(a.rgb * a.a) + vec3(b.rgb * b.a), a.a + b.a), vec4(0), vec4(1));
}

vec4 blend_union_add(vec4 a, vec4 b) {
	a.a = a.a * b.a;
	b.a = a.a;
	return blend_add(a, b);
}

vec4 blend_union_mix(vec4 a, vec4 b) {
	a.a = a.a * b.a;
	b.a = a.a;
	return blend_mix(a, b);
}