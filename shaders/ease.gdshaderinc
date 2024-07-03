float ease_in(float t, float p) {
	return pow(t, p);
}

float ease_out(float t, float p) {
	return 1. - pow(1. - t, p);
}

float ease(float t, float p) {
	if (t < 0.5) {
		return pow(2., p - 1.) * pow(t, p);
	} else {
		return 1. - pow(-2. * t + 2., p) / 2.;
	}
}