shader_type canvas_item;

#include "res://shaders/animation.gdshaderinc"
#include "res://shaders/blend.gdshaderinc"
#include "res://shaders/transform.gdshaderinc"
#include "res://shaders/sdf.gdshaderinc"

uniform float t = 0.0;
uniform bool start_end_invisible = true;


vec4 arrow(vec2 uv) {
	const float line_thickness = 0.15;
	const float height = 0.6;
	const float pointy_length = 0.25;
	const float outline_thickness = 0.025;
	const float pointy_angle = PI/4.;
	
	float d = sd_onion(sd_box(uv, vec2(0, height)), line_thickness);
	
	vec2 new_uv = rot2d_about_uv(translate_uv(uv, vec2(pointy_length, height)), vec2(-pointy_length, 0), -pointy_angle);
	d = min(d, sd_onion(sd_box(new_uv, vec2(pointy_length, 0)), line_thickness));
	
	new_uv = rot2d_about_uv(translate_uv(uv, vec2(pointy_length, height)), vec2(-pointy_length, 0), PI + pointy_angle);
	d = min(d, sd_onion(sd_box(new_uv, vec2(pointy_length, 0)), line_thickness));
	
	d = sd_onion(d, outline_thickness);
	
	
	return vec4(step(d, 0));
}


void fragment() {
	if (start_end_invisible && (t <= 0. || t >= 1.)) {
		COLOR = vec4(0);
	} else {
		vec2 uv = UV * 2. - 1.;
		vec4 c = vec4(0.3, 0.4, 1., 1.);

		float arrow_y = anim_ease(t, 0, 0.2, 0, 3) +
						anim_ease(t, 0.2, 1, 3, 0) + -3.;

		vec4 arrow = arrow(translate_uv(uv, vec2(0, arrow_y)));
		c = blend_union_mix(c, arrow);

		COLOR = c;
	}
}