#include "res://shaders/blend.gdshaderinc"
#include "res://shaders/transform.gdshaderinc"

uniform sampler2D foam_texture : source_color, repeat_enable;
uniform sampler2D foam_texture_2 : source_color, repeat_enable;

uniform sampler2D water_reflections : source_color, repeat_enable;
uniform sampler2D water_reflections_2 : source_color, repeat_enable;

uniform vec3 water_color : source_color;


float dist_from_land(float brightness, float t) {
	return brightness / .45 + sin(t) * 0.03 - 0.015;
}

float foam(float dist_from_land, vec2 uv) {
	float offset = TIME * 0.02 + sin(TIME * 0.4) * 0.02 - 0.01;
	float offset_2 = TIME * 0.02 + sin(TIME * 0.4 + 0.2) * 0.02 - 0.01;
	
	float foam_amount = texture(foam_texture, uv * 2. + offset * vec2(.866, .5)).r * 0.7;
	foam_amount += texture(foam_texture_2, uv * 2. + offset_2 * vec2(-.9848, -.1736)).r * 0.3;
	foam_amount = pow(foam_amount, 0.2) - 0.3 ;
	
	foam_amount = step(foam_amount, pow(dist_from_land+0.1, 3) * 0.5);
	
	return foam_amount;
}

float reflections(vec2 uv) {
	float offset = TIME * 0.02;
	float offset_2 = TIME * 0.02 + sin(TIME * 0.7) * 0.02 - 0.01;
	
	float ref_amount = texture(water_reflections, rot2d(uv, -1.) + vec2(.866, .5) * offset).r;
	ref_amount *= texture(water_reflections_2, rot2d(uv, 1.) * vec2(10, 1) + vec2(-.9848, -.1736) * offset).r;
	
	ref_amount = step(0.5, ref_amount);
	
	return ref_amount;
}

float deep_water(float d) {
	return clamp(1. - d, 0, 1);
}

float on_land(float brightness) {
	return clamp(1. - (dist_from_land(brightness, TIME - 0.3) - 1.) * 90., 0, 1) * 0.09;
}


vec4 water(float brightness, vec2 uv) {
	float d = dist_from_land(brightness, TIME);
	
	float foam_amount = foam(d, uv);
	float reflections_amount = reflections(uv);
	float deep_water_amount = deep_water(d);
	float on_land_amount = on_land(brightness);
	
	
	vec4 wc = vec4(water_color, 1.0);
	wc = blend_mix(vec4(water_color * vec3(0.5, 0.5, 0.7), deep_water_amount), wc);
	wc = blend_mix(vec4(1., 1., 1., reflections_amount * 0.2), wc);
	wc = blend_mix(vec4(.9, .9, 1., foam_amount), wc);
	wc.a = step(d, 1.);
	
	vec4 lc = vec4(0.);
	lc = blend_mix(vec4(0., 0., 0.3, on_land_amount), lc);
	
	
	return blend_mix(wc, lc);
}