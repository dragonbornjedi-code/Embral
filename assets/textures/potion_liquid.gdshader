shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;

// === POTION LIQUID SHADER ===
// Supports: gradients, swirls, glitter, multi-color effects

// Base colors
uniform vec4 color_primary : source_color = vec4(0.0, 0.3, 0.8, 1.0);
uniform vec4 color_secondary : source_color = vec4(0.0, 0.6, 1.0, 1.0);
uniform vec4 color_accent : source_color = vec4(1.0, 1.0, 1.0, 1.0);

// Effect controls
uniform float gradient_blend : hint_range(0.0, 1.0) = 0.5;
uniform float swirl_speed : hint_range(0.0, 5.0) = 1.0;
uniform float swirl_intensity : hint_range(0.0, 1.0) = 0.3;
uniform float glitter_amount : hint_range(0.0, 1.0) = 0.2;
uniform float glitter_size : hint_range(0.001, 0.1) = 0.02;
uniform float glow_strength : hint_range(0.0, 2.0) = 0.5;
uniform float transparency : hint_range(0.0, 1.0) = 0.15;

// Animation
uniform float bubble_speed : hint_range(0.0, 3.0) = 0.5;
uniform float wave_speed : hint_range(0.0, 3.0) = 1.0;

// Random function for glitter
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Noise for swirl effect
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

void fragment() {
    vec2 uv = UV;
    float time = TIME;

    // === GRADIENT (vertical blend between colors) ===
    float gradient = smoothstep(0.0, 1.0, uv.y + sin(time * wave_speed + uv.x * 3.0) * 0.1);
    vec3 base_color = mix(color_primary.rgb, color_secondary.rgb, gradient * gradient_blend);

    // === SWIRL EFFECT ===
    if (swirl_intensity > 0.0) {
        vec2 swirl_uv = uv - 0.5;
        float angle = atan(swirl_uv.y, swirl_uv.x);
        float dist = length(swirl_uv);
        float swirl = sin(angle * 3.0 + time * swirl_speed + dist * 10.0) * swirl_intensity;
        base_color = mix(base_color, color_accent.rgb, swirl * 0.5 + 0.5);
    }

    // === BUBBLES (rising particles) ===
    if (bubble_speed > 0.0) {
        vec2 bubble_uv = uv * 20.0;
        bubble_uv.y -= time * bubble_speed;
        float bubble = step(0.95, random(floor(bubble_uv)));
        base_color += vec3(bubble * 0.3);
    }

    // === GLITTER SPARKLE ===
    if (glitter_amount > 0.0) {
        vec2 glitter_uv = uv / glitter_size;
        float glitter = random(floor(glitter_uv) + floor(time * 5.0));
        glitter = step(1.0 - glitter_amount * 0.1, glitter);
        // Sparkle with accent color
        base_color += color_accent.rgb * glitter * 2.0;
    }

    // === OUTPUT ===
    ALBEDO = base_color;
    EMISSION = base_color * glow_strength;
    ALPHA = 1.0 - transparency;
    METALLIC = 0.1;
    ROUGHNESS = 0.2;
    SPECULAR = 0.8;
}
