#version 140

in mediump vec2 var_texcoord0;

out vec4 out_fragColor;

uniform mediump sampler2D texture_sampler;
uniform fs_uniforms
{
    mediump vec4 tint;
    mediump vec4 minimap_color;
    mediump vec4 minimap_enabled;
};

void main()
{
    vec4 tex = texture(texture_sampler, var_texcoord0.xy);

	vec4 color;

	if (minimap_enabled.x > 0.5) {
		color = vec4(minimap_color.rgb * tex.a, tex.a);
	} else {
		mediump vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);
		color = tex * tint_pm;
	}

	out_fragColor = color;
}
