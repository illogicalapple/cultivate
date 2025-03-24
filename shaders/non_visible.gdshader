shader_type canvas_item;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float vision_range;
uniform float screen_width;
uniform float screen_height;

void fragment() {
	float ratio = screen_width / screen_height;
	float dist = distance(vec2(0.5, 0.5), vec2(mix(0.5, UV.x, ratio), UV.y));
	vec4 SCREEN_COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
	if(dist * screen_height > vision_range) {
		COLOR.rgb = vec3(0.299 * SCREEN_COLOR.r + 0.587 * COLOR.g + 0.114 * COLOR.b);
		COLOR.a = 1.0;
	}
}