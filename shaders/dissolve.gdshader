shader_type spatial;

uniform sampler2D noise_tex;
uniform float dissolve_amount : hint_range(0.0, 1.0) = 0.0;
uniform vec4 edge_color_hot : source_color = vec4(1.0, 1.0, 1.0, 1.0);   // white-hot core
uniform vec4 edge_color_outer : source_color = vec4(0.2, 0.8, 1.0, 1.0); // cyan outer glow
uniform float edge_width : hint_range(0.0, 0.3) = 0.12;
uniform float edge_glow : hint_range(0.0, 20.0) = 10.0;
uniform float pop_amount : hint_range(0.0, 0.5) = 0.15;
uniform vec4 albedo : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform sampler2D texture_albedo : source_color;

void vertex() {
	// Puff the mesh outward along its normal as it dissolves — a "popping" inflate
	VERTEX += NORMAL * dissolve_amount * pop_amount;
}

void fragment() {
	float noise_val = texture(noise_tex, UV).r;
	
	if (noise_val < dissolve_amount) {
		discard;
	}
	
	vec4 tex_color = texture(texture_albedo, UV);
	ALBEDO = tex_color.rgb * albedo.rgb;
	
	float dist_from_edge = noise_val - dissolve_amount;
	if (dist_from_edge < edge_width) {
		float edge_t = clamp(dist_from_edge / edge_width, 0.0, 1.0);
		// Hot white core right at the very edge, fading to cyan further back
		vec3 edge_mix = mix(edge_color_hot.rgb, edge_color_outer.rgb, edge_t);
		ALBEDO = edge_mix;
		EMISSION = edge_mix * edge_glow * (1.0 - edge_t * 0.5);
	}
}