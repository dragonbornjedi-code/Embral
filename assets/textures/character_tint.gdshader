shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;

// === CHARACTER TINT SHADER ===
// Apply color tints to textured models (baby dragons, NPCs, etc.)
// Preserves texture detail while allowing color variations

// Base texture (from GLB)
uniform sampler2D albedo_texture : source_color, filter_linear_mipmap, repeat_enable;

// Tint controls
uniform vec4 tint_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float tint_strength : hint_range(0.0, 1.0) = 0.5;
uniform float brightness : hint_range(0.5, 2.0) = 1.0;
uniform float saturation : hint_range(0.0, 2.0) = 1.0;
uniform float contrast : hint_range(0.5, 2.0) = 1.0;

// Rim lighting (edge glow)
uniform bool enable_rim = true;
uniform vec4 rim_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float rim_power : hint_range(0.5, 8.0) = 3.0;
uniform float rim_intensity : hint_range(0.0, 2.0) = 0.5;

// Emission/glow
uniform bool enable_emission = false;
uniform vec4 emission_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);
uniform float emission_strength : hint_range(0.0, 3.0) = 0.5;

// Animated effects
uniform float pulse_speed : hint_range(0.0, 5.0) = 0.0;
uniform float pulse_amount : hint_range(0.0, 0.5) = 0.1;

// Convert RGB to HSV
vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

// Convert HSV to RGB
vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
    // Sample base texture
    vec4 tex_color = texture(albedo_texture, UV);
    vec3 base_color = tex_color.rgb;

    // Apply tint (multiply blend)
    vec3 tinted = mix(base_color, base_color * tint_color.rgb, tint_strength);

    // Saturation adjustment
    vec3 hsv = rgb2hsv(tinted);
    hsv.y *= saturation;
    tinted = hsv2rgb(hsv);

    // Contrast adjustment
    tinted = ((tinted - 0.5) * contrast) + 0.5;

    // Brightness adjustment
    tinted *= brightness;

    // Pulse animation
    float pulse = 1.0;
    if (pulse_speed > 0.0) {
        pulse = 1.0 + sin(TIME * pulse_speed) * pulse_amount;
        tinted *= pulse;
    }

    // Rim lighting
    vec3 rim_contribution = vec3(0.0);
    if (enable_rim) {
        float rim = 1.0 - dot(NORMAL, VIEW);
        rim = pow(rim, rim_power);
        rim_contribution = rim_color.rgb * rim * rim_intensity;
    }

    // Final output
    ALBEDO = clamp(tinted + rim_contribution, 0.0, 1.0);
    ALPHA = tex_color.a * tint_color.a;

    // Emission
    if (enable_emission) {
        EMISSION = emission_color.rgb * emission_strength * pulse;
    }

    // Material properties
    METALLIC = 0.0;
    ROUGHNESS = 0.7;
    SPECULAR = 0.3;
}
