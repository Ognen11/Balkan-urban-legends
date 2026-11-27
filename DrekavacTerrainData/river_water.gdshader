shader_type spatial;
render_mode blend_mix, depth_draw_never, cull_disabled, shadows_disabled;

uniform sampler2D scene_depth : hint_depth_texture, repeat_disable, filter_nearest;

varying vec3 world_position;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

vec3 riverbed_position(vec2 screen_uv, float depth, mat4 inverse_projection, mat4 inverse_view) {
	#if CURRENT_RENDERER == RENDERER_COMPATIBILITY
		vec3 ndc = vec3(screen_uv, depth) * 2.0 - 1.0;
	#else
		vec3 ndc = vec3(screen_uv * 2.0 - 1.0, depth);
	#endif
	vec4 view_position = inverse_projection * vec4(ndc, 1.0);
	return (inverse_view * vec4(view_position.xyz / view_position.w, 1.0)).xyz;
}

void fragment() {
	vec2 p = world_position.xz;
	float current_shift = sin(p.x * 0.08 + p.y * 0.063 + TIME * 0.42);
	float long_wave = p.x * 0.31 + p.y * 0.49 - TIME * 1.3 + current_shift * 1.6;
	float short_wave = p.x * 1.77 - p.y * 0.86 + TIME * 1.9 + current_shift * 1.1;
	vec2 slope = 0.071 * cos(long_wave) * vec2(0.31, 0.49)
		+ 0.024 * cos(short_wave) * vec2(1.77, -0.86);
	NORMAL = mat3(VIEW_MATRIX) * normalize(vec3(-slope.x, 1.0, -slope.y));

	float depth_sample = texture(scene_depth, SCREEN_UV).r;
	float water_depth = 7.65;
	if (depth_sample > 0.0) {
		vec3 bed = riverbed_position(SCREEN_UV, depth_sample, INV_PROJECTION_MATRIX, INV_VIEW_MATRIX);
		water_depth = max(0.0, world_position.y - bed.y);
	}
	float depth_tint = smoothstep(0.12, 7.2, water_depth);
	float grazing = pow(1.0 - clamp(abs(dot(NORMAL, VIEW)), 0.0, 1.0), 4.0);
	float shoreline = smoothstep(0.0, 0.24, water_depth);

	ALBEDO = mix(vec3(0.041, 0.082, 0.076), vec3(0.018, 0.057, 0.076), depth_tint);
	EMISSION = ALBEDO * 0.15;
	ROUGHNESS = mix(0.30, 0.20, depth_tint);
	SPECULAR = 0.55;
	ALPHA = shoreline * mix(mix(0.14, 0.50, depth_tint), 0.77, grazing);
}
