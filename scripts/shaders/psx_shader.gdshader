shader_type canvas_item;

global uniform vec2 resolution;
global uniform float color_depth;
uniform float dither_amount: hint_range(0.0, 1.0, 0.01) = 0.5;
uniform vec4 hue_tint : source_color = vec4(1.0, 1.0, 1.0, 1.0);

const mat4 bayer_matrix = (1.0 / 16.0) * mat4(
	vec4(0.0, 8.0, 2.0, 10.0),
	vec4(12.0, 4.0, 14.0, 6.0),
	vec4(3.0, 11.0, 1.0, 9.0),
	vec4(15.0, 7.0, 13.0, 9.0)
) - 0.5;

uniform sampler2D screen_texture: hint_screen_texture, filter_nearest;

void fragment() {
	vec2 uv = floor(SCREEN_UV * resolution) / resolution;
	ivec2 int_uv = ivec2(uv * resolution);

	vec4 tex_color = texture(screen_texture, uv);
	vec3 linear_color = pow(tex_color.rgb, vec3(2.2));

	vec3 dithered_color = linear_color + bayer_matrix[int_uv.x % 4][int_uv.y % 4] / color_depth * dither_amount;
	vec3 quantized_color = round(dithered_color * color_depth) / color_depth;

	vec3 final_color = pow(clamp(quantized_color, 0.0, 1.0), vec3(1.0/2.2));

	COLOR = vec4(final_color * hue_tint.rgb, tex_color.a);
}
