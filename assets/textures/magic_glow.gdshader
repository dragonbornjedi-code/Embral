shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, unshaded;

// === MAGIC GLOW SHADER ===
// Use on any object that needs magical glowing effect
// Great for: coins, crystals, quest items, power-ups

uniform vec4 glow_color : source_color = vec4(1.0, 0.8, 0.0, 1.0);
uniform vec4 secondary_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float glow_intensity : hint_range(0.0, 3.0) = 1.5;
uniform float pulse_speed : hint_range(0.0, 5.0) = 2.0;
uniform float pulse_amount : hint_range(0.0, 1.0) = 0.3;
uniform float fresnel_power : hint_range(0.1, 5.0) = 2.0;
uniform bool enable_sparkle = true;
uniform float sparkle_amount : hint_range(0.0, 1.0) = 0.3;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
    float time = TIME;

    // Pulsing glow
    float pulse = 1.0 + sin(time * pulse_speed) * pulse_amount;

    // Fresnel edge glow (brighter at edges)
    float fresnel = pow(1.0 - dot(NORMAL, VIEW), fresnel_power);

    // Base color with fresnel
    vec3 color = mix(glow_color.rgb, secondary_color.rgb, fresnel * 0.5);

    // Sparkle effect
    if (enable_sparkle) {
        vec2 sparkle_uv = UV * 30.0;
        float sparkle = random(floor(sparkle_uv) + floor(time * 8.0));
        sparkle = step(1.0 - sparkle_amount * 0.15, sparkle);
        color += vec3(sparkle);
    }

    ALBEDO = color * glow_intensity * pulse;
    EMISSION = color * glow_intensity * pulse * 0.5;
}
