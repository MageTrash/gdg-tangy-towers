shader_type canvas_item;
render_mode blend_add;

const float TAU = 6.283185307;

uniform int square_size = 100;
uniform float circle_diameter : hint_range(0.,200.) = 80.;
uniform float min_alpha:hint_range(0.,1.) = 0.3;
uniform float max_alpha:hint_range(0.,1.) = 0.5;
uniform float wave_intensity:hint_range(0.,10.) = 2.;
uniform float wave_frequency:hint_range(0.,10.) = 2.;
uniform vec4 col1:hint_color = vec4(vec3(0.),1.);
uniform vec4 col2:hint_color = vec4(1.);


// Sine wave function, shifted to be between 0.0 and 1.0
float mod_sin(float x, float lower, float upper) {
	float bounds = upper-lower;
	float shift = lower + 0.5 * bounds;
	return sin(x)/2.0*bounds + shift;
}

void fragment() {
	// Simple pixelUV generator.
	vec2 pixelUV = round( (UV+0.5 *1./float(square_size) )*float(square_size) )/float(square_size);
	
	// Very simple circle generator, for our alpha limits.
	float radial_dist = distance(pixelUV, vec2(0.5)); //Distance distribution from centre (0.5, 0.5);
	float circle = step(radial_dist, (circle_diameter)/(2.*float(square_size)) );
	
	// Simple "wave" generators
	float y1 = abs(fract(TIME + radial_dist * wave_intensity) * 2. - 1.); //Triangle wave
	float y2 = smoothstep(0.0, mod_sin(TIME*wave_frequency, 0.0, -1.0), radial_dist);//Smoothened sine
	float y3 = mod_sin(-TIME*wave_frequency + radial_dist*wave_intensity, -0.3, 1.0); //Sine wave
	
	float y4 = step(abs(fract(-TIME*wave_frequency + radial_dist * wave_intensity) * 2. - 1.), 0.1); //Stepped triangle wave
	
	// Assigning the formulae to the color.
	vec4 color = vec4(1.0);
	color.rgb = col1.rgb;
	color.a = (circle*y4)*max_alpha;
	COLOR = color;
	
}