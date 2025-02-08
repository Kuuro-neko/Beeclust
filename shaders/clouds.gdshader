shader_type canvas_item;

uniform sampler2D noiseTexture;

uniform bool isSoft = false;
uniform float speed : hint_range(0.0, 1.0) = 0.1;
uniform float brightness : hint_range(0.0, 2.0) = 0.1;
uniform float threshold : hint_range(0.0, 2.0) = 0.1;
uniform float fluffiness : hint_range(0.0, 2.0) = 0.1;

void fragment() {
    vec2 uv1 = mod(UV + TIME * 2.5 * speed * 0.1, 1.0);
    vec2 uv2 = mod(UV + TIME * (2.5 + fluffiness * 3.0) * speed * 0.1, 1.0);

    vec4 noise1 = texture(noiseTexture, uv1);
    vec4 noise2 = texture(noiseTexture, uv2);

    vec4 combinedNoise = max(noise1, noise2);
    float noiseIntensity = combinedNoise.r;

    float alphaValue;
    if (isSoft) {
        alphaValue = smoothstep(threshold - 0.3, threshold + 0.3, noiseIntensity);
    }
    else {
        alphaValue = noiseIntensity < threshold ? 0.0 : 1.0;
    }

    vec3 shadowColor = vec3(0.0);
    COLOR = vec4(shadowColor, alphaValue * brightness);
}
