shader_type canvas_item;

#include "res://shaders/animation.gdshaderinc"
#include "res://shaders/blend.gdshaderinc"
#include "res://shaders/transform.gdshaderinc"
#include "res://shaders/sdf.gdshaderinc"
#include "res://shaders/math.gdshaderinc"
#include "res://shaders/ease.gdshaderinc"

uniform float t = 0.0;
uniform vec4 ring_color : source_color = vec4(0.22, 0.43, 0.87, 1.);
uniform bool start_end_invisible = true;

//
//vec4 arrow(vec2 uv) {
	//const float line_thickness = 0.15;
	//const float height = 0.6;
	//const float pointy_length = 0.25;
	//const float outline_thickness = 0.025;
	//const float pointy_angle = PI/4.;
	//
	//
	//float y = anim_ease(t, 0, 0.2, 0, 3) +
					//anim_ease(t, 0.2, 1, 3, 0) + -3.;
//
	//uv = translate_uv(uv, vec2(0, y));
	//
	//
	//float d = sd_onion(sd_box(uv, vec2(0, height)), line_thickness);
	//
	//vec2 new_uv = rot2d_about_uv(translate_uv(uv, vec2(pointy_length, height)), vec2(-pointy_length, 0), -pointy_angle);
	//d = min(d, sd_onion(sd_box(new_uv, vec2(pointy_length, 0)), line_thickness));
	//
	//new_uv = rot2d_about_uv(translate_uv(uv, vec2(pointy_length, height)), vec2(-pointy_length, 0), PI + pointy_angle);
	//d = min(d, sd_onion(sd_box(new_uv, vec2(pointy_length, 0)), line_thickness));
	//
	//d = sd_onion(d, outline_thickness);
	//
	//
	//return vec4(step(d, 0));
//}


vec4 ring(vec2 uv) {
	float r = ease_out(t, 1.5);

	const float max_r = 0.8;
	const float outline = 0.05;

	vec2 new_uv = scale_uv(uv, vec2(1, 0.75));
	float d = sd_onion(sd_circle(new_uv, r), map(r, 0, max_r, outline, 0));

	return vec4(1, 1, 1, step(d, 0));
}


void fragment() {
	if (start_end_invisible && (t <= 0. || t >= 1.)) {
		COLOR = vec4(0);
	} else {
		vec2 uv = UV * 2. - 1.;
		vec4 c = ring_color;

		c *= ring(uv);
		COLOR = c;
	}
}