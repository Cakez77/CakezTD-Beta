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

void main()
{
    vec4 color = texture(sprite, uv);
    if(color.a == 0)
    {
        discard;
    }

    MaterialData material = materials[materialIdx];
    fragColor = color * material.color;
}