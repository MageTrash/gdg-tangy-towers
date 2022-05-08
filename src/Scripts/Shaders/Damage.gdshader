shader_type canvas_item;

uniform vec4 flashColor : hint_color;
uniform float flashState : hint_range(0, 1) = 0.0;

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);
	COLOR = mix(pixelColor, flashColor, flashState);
	COLOR.a = pixelColor.a;
}