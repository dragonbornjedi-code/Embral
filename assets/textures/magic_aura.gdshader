shader_type spatial;
render_mode blend_add, depth_draw_opaque, cull_front, unshaded;

// === MAGIC AURA SHADER ===
// Add magical glowing aura effects around characters
// Apply to a slightly scaled-up duplicate mesh behind the character

// Aura colors
uniform vec4 inner_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);
uniform vec4 outer_color : source_color = vec4(1.0, 0.2, 0.0, 0.5);

// Aura properties
uniform float aura_intensity : hint_range(0.0, 3.0) = 1.0;
uniform float aura_size : hint_range(0.0, 1.0) = 0.3;
uniform float fresnel_power : hint_range(0.5, 8.0) = 2.0;

// Animation
uniform float pulse_speed : hint_range(0.0, 5.0) = 2.0;
uniform float pulse_amount : hint_range(0.0, 1.0) = 0.3;
uniform float wave_speed : hint_range(0.0, 5.0) = 1.0;
uniform float wave_amount : hint_range(0.0, 0.5) = 0.1;

// Noise for organic feel
uniform float noise_scale : hint_range(1.0, 20.0) = 5.0;
uniform float noise_speed : hint_range(0.0, 3.0) = 0.5;

// Particle-like sparkles
uniform bool enable_sparkles = true;
uniform float sparkle_amount : hint_range(0.0, 1.0) = 0.3;
uniform float sparkle_speed : hint_range(1.0, 10.0) = 5.0;

// Random function
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Simple noise
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void vertex() {
    // Expand mesh outward for aura
    VERTEX += NORMAL * aura_size;

    // Add wave distortion
    if (wave_amount > 0.0) {
        float wave = sin(VERTEX.y * 5.0 + TIME * wave_speed) * wave_amount;
        VERTEX += NORMAL * wave;
    }
}

void fragment() {
    float time = TIME;

    // Fresnel for edge glow
    float fresnel = pow(1.0 - abs(dot(NORMAL, VIEW)), fresnel_power);

    // Noise for organic variation
    vec2 noise_uv = UV * noise_scale + vec2(time * noise_speed, 0.0);
    float n = noise(noise_uv);

    // Pulse animation
    float pulse = 1.0 + sin(time * pulse_speed) * pulse_amount;

    // Mix inner and outer colors based on fresnel
    vec3 aura_color = mix(inner_color.rgb, outer_color.rgb, fresnel);

    // Apply noise variation
    aura_color *= 0.8 + n * 0.4;

    // Sparkles
    if (enable_sparkles) {
        vec2 sparkle_uv = UV * 30.0;
        float sparkle = random(floor(sparkle_uv) + floor(time * sparkle_speed));
        sparkle = step(1.0 - sparkle_amount * 0.1, sparkle);
        aura_color += vec3(sparkle) * 2.0;
    }

    // Final intensity
    float alpha = fresnel * aura_intensity * pulse;
    alpha *= mix(inner_color.a, outer_color.a, fresnel);

    // Fade out edges more
    alpha *= smoothstep(0.0, 0.3, fresnel);

    ALBEDO = aura_color;
    ALPHA = clamp(alpha, 0.0, 1.0);
}
