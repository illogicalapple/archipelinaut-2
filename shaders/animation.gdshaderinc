#include "ease.gdshaderinc"

float anim_linear(float t, float st, float et, float s, float e) {
	return mix(s, e, (t - st) / (et - st)) * float(t > st && t <= et);
}

float anim_ease(float t, float st, float et, float s, float e, float p) {
	return mix(s, e, ease((t - st) / (et - st), p)) * float(t > st && t <= et);
}