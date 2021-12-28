#version 450

#include "../../src/Renderer/shared_render_types.h"

layout(location = 0) in vec2 uv;
layout(location = 1) in flat uint materialIdx;

layout(location = 0) out vec4 fragColor;

layout(set = 0, binding = 2) readonly buffer MaterialSBO
{
    MaterialData materials[];
};

layout(set = 1, binding = 0) uniform sampler2D sprite;

layout(push_constant) uniform block
{
    PushData pushData;
};

// These reference alpha values
const float width = 0.5;
const float edge = 0.01;

const float borderWidth = 0.58;
const float borderEdge = 0.01;

const float glyphOffset = 0.004;

vec4 borderColor = vec4(0.0, 0.0, 0.0, 0.5);
vec4 transparentColor = vec4(0.0, 0.0, 0.0, 0.0);

void main()
{
    vec4 sdfColor = texture(sprite, uv);
    if(sdfColor.a == 0)
    {
        discard;
    }

    vec2 uvOffset = vec2(uv.x + glyphOffset, uv.y - glyphOffset);

    // Normal SDF sampling
    float fillDist = 1.0 - sdfColor.a;
    float fillAlpha = 1.0 - smoothstep(width, width + edge, fillDist);

    // Offset Sample 
    float borderDist = 1.0 - texture(sprite, uvOffset).a;
    float borderAlpha = 1.0 - smoothstep(borderWidth, borderWidth + borderEdge, borderDist);

    // Draw the Border Glyph (at offset)
    fragColor = mix(transparentColor, borderColor, borderAlpha);

    // Draw the Actual Glyph (draws over Border)
    fragColor = mix(fragColor, materials[materialIdx].color, fillAlpha);
}