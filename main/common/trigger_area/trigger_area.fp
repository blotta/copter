#version 140

in highp vec2 var_texcoord0;

out vec4 out_fragColor;

uniform highp sampler2D texture_sampler;
uniform fs_uniforms
{
    mediump vec4 tint;
    highp vec4 time;
};

void main()
{
	vec2 uv = var_texcoord0.xy;
    float edge = abs(uv.x - 0.5) * 2.0;

    if (uv.x < 0.5) {
        uv.x -= time.x / 2;
    } else {
        uv.x += time.x / 2;
    }
	vec4 color = texture(texture_sampler, uv);

    // edges faded
    float fade = abs(sin(var_texcoord0.x * 2.0 * 3.14159265));
    color *= fade;

    // float dist = abs(var_texcoord0.x - 0.5);
    // float fade = 1.0 - smoothstep(0.4, 0.01, dist);
    // color *= fade;

    // float alpha = 1.0 - (1.0 - edge);
    // float alpha = (1.0 - edge);
    // float final_alpha = color.a * alpha;
    // vec3 final_rgb = color.rgb * alpha;
    // color = vec4(final_rgb, final_alpha);

    // Pre-multiply alpha since all runtime textures already are
    // mediump vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);
    // color = color * tint_pm;

    out_fragColor = color;
}
