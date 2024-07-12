shader_type canvas_item;

#include "res://shaders/blend.gdshaderinc"
#include "res://shaders/transform.gdshaderinc"

uniform vec3 water_color_shallow : source_color = vec3(0.44, 0.75, 0.87);
uniform vec3 water_color_deep : source_color = vec3(0.44, 0.75, 0.87);

uniform sampler2D waves_tex : repeat_enable;
uniform sampler2D reflection_displacement : repeat_enable;

uniform sampler2D reflection_texture : source_color;

float waves_base(float d) {
	return step(sin(d * 300. - TIME + sin(TIME * 2.)), -0.3);
}

vec4 waves(float d) {
	float waves = waves_base(d);
	waves *= d * -100. + 5.;
	waves = clamp(waves, 0, 1);

	return vec4(vec3(1), waves);
}

vec4 specular(float d, vec2 uv) {
	vec2 rot_uv = rot2d(uv, -0.1);

	float refl_amount = step(texture(waves_tex, rot_uv * vec2(0.1) + vec2(TIME * 0.001, sin(TIME * 0.002))).r, 0.995) *
		step(texture(waves_tex, rot_uv * vec2(.1, 1) + vec2(TIME * -0.005, sin(TIME * -0.01))).r, 0.5);

	return vec4(1, 1, 1, refl_amount);
}

vec4 deep_water(float d) {
	return vec4(vec3(1), step(d, .1 + sin(TIME * 0.5) * 0.01));
}

vec4 reflections(vec2 uv, vec2 screen_uv) {
	vec2 d_uv = rot2d(uv, -.35) * vec2(0.5, 2.5) + vec2(sin(TIME * 0.01), sin(TIME * 0.01)) + vec2(TIME * 0.01, TIME * 0.02);
	float displacement = texture(reflection_displacement, d_uv).r;
	screen_uv.x += (displacement - 0.5) * 0.01;

	vec4 c = texture(reflection_texture, screen_uv);
	c.a = step(1, c.a);

	return c;
}


vec4 water(sampler2D tex, vec2 uv, vec2 screen_uv) {
	// Distance to land, is negative if on land, rough estimation based on texture
	float d = -(texture(tex, uv).r - .45);

	vec4 c = vec4(water_color_shallow, 1);

	c = blend_mix(deep_water(d) * vec4(water_color_deep, 1), c);
	c = blend_mix(reflections(uv, screen_uv) * vec4(0.9, 1, 1.1, 1), c);

	vec4 specular = blend_add(waves(d), specular(d, uv));
	c = blend_add(specular * vec4(0.5, 0.5, 1, 0.3), c);

	return c;
}

vec4 sand(vec2 uv) {
	vec4 c = vec4(1, 0.96, 0.7, 1);

	// c = blend_mix(vec4(light_pebbles_color, texture(sand_texture, rot2d(uv * 2., 3)).r), c);
	// c = blend_mix(vec4(dark_pebbles_color, texture(sand_texture, uv).r), c);

	return c;
}


void fragment() {
	float brightness = texture(TEXTURE, UV).r;
	if (brightness > 0.55) {
		COLOR = vec4(0.81, 0.88, 0.54, 1);
	} else if (brightness > 0.45) {
		COLOR = vec4(1, 0.96, 0.7, 1);
	} else {
		COLOR = water(TEXTURE, UV, SCREEN_UV);
	}
}