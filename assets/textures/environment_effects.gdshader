shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;

// === ENVIRONMENT EFFECTS SHADER ===
// For buildings, towers, trees, and environment objects
// Supports: time of day, weather, magical effects, holiday themes

// Base texture
uniform sampler2D albedo_texture : source_color, filter_linear_mipmap, repeat_enable;

// Time of day tinting
uniform bool enable_time_tint = true;
uniform vec4 day_tint : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 sunset_tint : source_color = vec4(1.0, 0.7, 0.5, 1.0);
uniform vec4 night_tint : source_color = vec4(0.4, 0.4, 0.6, 1.0);
uniform float time_of_day : hint_range(0.0, 24.0) = 12.0; // 0-24 hours

// Weather effects
uniform bool enable_rain_wet = false;
uniform float wetness : hint_range(0.0, 1.0) = 0.5;
uniform bool enable_snow = false;
uniform float snow_amount : hint_range(0.0, 1.0) = 0.5;
uniform float snow_height : hint_range(0.0, 1.0) = 0.8; // Y threshold

// Magical effects
uniform bool enable_magical = false;
uniform vec4 magic_color : source_color = vec4(0.5, 0.3, 1.0, 1.0);
uniform float magic_intensity : hint_range(0.0, 2.0) = 0.5;
uniform float magic_pulse_speed : hint_range(0.0, 5.0) = 2.0;

// Holiday lights
uniform bool enable_holiday_lights = false;
uniform vec4 light_color_1 : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 light_color_2 : source_color = vec4(0.0, 1.0, 0.0, 1.0);
uniform vec4 light_color_3 : source_color = vec4(0.0, 0.0, 1.0, 1.0);
uniform float light_speed : hint_range(0.5, 5.0) = 1.5;

// Haunted/spooky effects
uniform bool enable_haunted = false;
uniform float fog_amount : hint_range(0.0, 1.0) = 0.3;
uniform vec4 fog_color : source_color = vec4(0.2, 0.3, 0.2, 1.0);

// Window glow
uniform bool enable_window_glow = false;
uniform vec4 window_color : source_color = vec4(1.0, 0.9, 0.6, 1.0);
uniform float window_threshold : hint_range(0.0, 1.0) = 0.8; // Bright areas = windows

// Random function
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Calculate time of day tint
vec3 get_time_tint() {
    float hour = time_of_day;

    // Dawn: 5-8, Day: 8-17, Sunset: 17-20, Night: 20-5
    if (hour >= 5.0 && hour < 8.0) {
        float t = (hour - 5.0) / 3.0;
        return mix(night_tint.rgb, sunset_tint.rgb, t);
    } else if (hour >= 8.0 && hour < 17.0) {
        return day_tint.rgb;
    } else if (hour >= 17.0 && hour < 20.0) {
        float t = (hour - 17.0) / 3.0;
        return mix(day_tint.rgb, sunset_tint.rgb, t);
    } else if (hour >= 20.0 && hour < 22.0) {
        float t = (hour - 20.0) / 2.0;
        return mix(sunset_tint.rgb, night_tint.rgb, t);
    } else {
        return night_tint.rgb;
    }
}

void fragment() {
    // Sample base texture
    vec4 tex_color = texture(albedo_texture, UV);
    vec3 color = tex_color.rgb;

    // === TIME OF DAY ===
    if (enable_time_tint) {
        vec3 time_tint = get_time_tint();
        color *= time_tint;
    }

    // === RAIN/WET EFFECT ===
    if (enable_rain_wet) {
        // Darken and add specular
        color *= 1.0 - wetness * 0.2;
        ROUGHNESS = mix(0.7, 0.2, wetness);
        SPECULAR = mix(0.3, 0.8, wetness);
    } else {
        ROUGHNESS = 0.7;
        SPECULAR = 0.3;
    }

    // === SNOW ===
    if (enable_snow) {
        // Add white to upper surfaces (based on UV.y or world normal)
        float snow_mask = smoothstep(snow_height - 0.1, snow_height + 0.1, UV.y);
        snow_mask *= snow_amount;
        // Also check if surface faces up
        float up_facing = max(0.0, dot(NORMAL, vec3(0.0, 1.0, 0.0)));
        snow_mask *= up_facing;
        color = mix(color, vec3(0.95, 0.97, 1.0), snow_mask);
    }

    // === MAGICAL GLOW ===
    vec3 emission = vec3(0.0);
    if (enable_magical) {
        float pulse = 1.0 + sin(TIME * magic_pulse_speed) * 0.3;
        float edge_glow = pow(1.0 - abs(dot(NORMAL, VIEW)), 2.0);
        emission += magic_color.rgb * magic_intensity * pulse * edge_glow;
    }

    // === HOLIDAY LIGHTS ===
    if (enable_holiday_lights) {
        // Animated twinkling lights
        vec2 light_uv = UV * 20.0;
        float light_id = floor(random(floor(light_uv)) * 3.0);
        float twinkle = sin(TIME * light_speed + random(floor(light_uv)) * 6.28) * 0.5 + 0.5;
        twinkle = step(0.7, twinkle);

        vec3 light_color;
        if (light_id < 1.0) {
            light_color = light_color_1.rgb;
        } else if (light_id < 2.0) {
            light_color = light_color_2.rgb;
        } else {
            light_color = light_color_3.rgb;
        }

        // Only add lights at certain density
        float is_light = step(0.92, random(floor(light_uv) + vec2(42.0, 17.0)));
        emission += light_color * twinkle * is_light * 2.0;
    }

    // === HAUNTED/FOG ===
    if (enable_haunted) {
        float fog_noise = random(UV * 5.0 + TIME * 0.1);
        float fog_mask = smoothstep(0.3, 0.7, fog_noise) * fog_amount;
        color = mix(color, fog_color.rgb, fog_mask);
        // Desaturate slightly
        float gray = dot(color, vec3(0.299, 0.587, 0.114));
        color = mix(color, vec3(gray), 0.3);
    }

    // === WINDOW GLOW ===
    if (enable_window_glow) {
        float brightness = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
        if (brightness > window_threshold) {
            // This is likely a window - make it glow at night
            float night_factor = 1.0 - smoothstep(7.0, 8.0, time_of_day) + smoothstep(18.0, 20.0, time_of_day);
            emission += window_color.rgb * night_factor * 0.8;
        }
    }

    // === OUTPUT ===
    ALBEDO = color;
    EMISSION = emission;
    ALPHA = tex_color.a;
    METALLIC = 0.0;
}
