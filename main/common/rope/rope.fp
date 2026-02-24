#version 140

in highp vec2 var_texcoord0;

out vec4 out_fragColor;

uniform highp sampler2D texture_sampler;
uniform fs_uniforms
{
    mediump vec4 tint;
    highp vec4 repeat_factor;
};

void main()
{
	vec2 uv = var_texcoord0.xy;
	uv.y *= repeat_factor.x;

	vec4 color = texture(texture_sampler, uv);

    // Pre-multiply alpha since all runtime textures already are
    mediump vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);

    out_fragColor = color * tint_pm;
}
