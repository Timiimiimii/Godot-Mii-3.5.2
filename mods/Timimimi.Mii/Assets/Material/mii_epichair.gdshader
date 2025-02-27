// NOTE: Shader automatically converted from Godot Engine 3.5.2.stable's SpatialMaterial.

shader_type spatial;
// render_mode async_visible,blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color;
uniform float specular;
uniform float metallic;
uniform float alpha_scissor_threshold;
uniform float roughness : hint_range(0,1);
uniform float point_size : hint_range(0,128);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;


void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
}




void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	albedo_tex.rgb = mix(pow((albedo_tex.rgb + vec3(0.055)) * (1.0 / (1.0 + 0.055)),vec3(2.4)),albedo_tex.rgb.rgb * (1.0 / 12.92),lessThan(albedo_tex.rgb,vec3(0.04045)));
	albedo_tex *= COLOR;
	
	vec4 albedo_out;
	vec4 albedoLim;
	
	
	albedo_out.rgb = albedo.rgb * vec3(albedo_tex.a);
	
	//ALBEDO = albedo.rgb * albedo_tex.rgb;
	ALBEDO = albedo_out.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
	ALPHA = 1.0;
	ALPHA_SCISSOR_THRESHOLD=alpha_scissor_threshold;
}
