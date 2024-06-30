vec4 blend_mix(vec4 c1, vec4 c2) {
	vec4 c = mix(c2, c1, c1.a);
	c.a = min(c1.a + c2.a, 1.);
	return c;
}