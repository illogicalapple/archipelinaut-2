shader_type canvas_item;

#include "res://shaders/blend.gdshaderinc"
#include "res://shaders/transform.gdshaderinc"
#include "res://shaders/sdf.gdshaderinc"
#include "res://shaders/random.gdshaderinc"
#include "res://shaders/math.gdshaderinc"

uniform float seed = 0;

uniform vec3 base_color : source_color = vec3(0.712);
uniform vec3 color_variation : source_color = vec3(0.133, 0.043, 0.125);

uniform float pile_radius = 0.82;
uniform float max_pebbles = 19.;

uniform float base_scale = 0.09;
uniform float scale_variation = 0.06;

uniform float squish_variation = 0.295;
uniform float rotation_variation = 3.1416;


vec4 pebble(vec2 uv, vec2 p, float s, float squish, float r, vec3 color_offset) {
	vec4 c = vec4(0);
	
	uv = scale_uv(rot2d_uv(translate_uv(uv, p), r), vec2(1, squish));
	float d = sd_circle(uv, s);
	
	c = vec4((base_color + color_offset), 1) * step(d, 0);
	
	return c;
}


void fragment() {
	vec2 uv = UV * 2. - 1.;
	float randi = 0.;
	
	vec4 c = vec4(0);
	
	float num_of_pebbles = floor(random(vec2(seed, randi)) * max_pebbles) + 1.;
	randi++;
	
	for (float i = 0.; i < num_of_pebbles; i++) {
		vec2 p;
		
		do {
			p = random2(vec2(seed, randi)) * 2. - 1.;
			randi++;
		} while (length(p) > pile_radius);
		
		float s = map(random(vec2(seed, randi)), 0, 1, base_scale, base_scale + scale_variation);
		randi++;
		
		float squish = map(random(vec2(seed, randi)), 0, 1, 1, 1. - squish_variation);
		randi++;
		
		float r = map(random(vec2(seed, randi)), 0, 1, -rotation_variation, rotation_variation);
		randi++;
		
		vec3 color_offset = map3(random3(vec2(seed, randi)), vec3(0), vec3(1), vec3(0), color_variation);
		randi++;
		
		c = blend_mix(pebble(uv, p, s, squish, r, color_offset), c);
	}
	
	
	COLOR = c;
}