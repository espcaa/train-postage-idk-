shader_type spatial;
render_mode cull_disabled;
uniform vec4 tint_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float tint_strength : hint_range(0.0, 1.0) = 0.5;
uniform sampler2D screen_tex : hint_screen_texture;

void fragment() {
    vec3 background = texture(screen_tex, SCREEN_UV).rgb;
    vec3 final_color = mix(background, tint_color.rgb, tint_strength);
    
    ALBEDO = final_color;
}
