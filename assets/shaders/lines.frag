#version 450

#include "../../src/Renderer/shared_render_types.h"

layout (location = 0) out vec4 fragColor;

vec2 lerp(vec2 p1, vec2 p2, float t)
{
    return (1 - t) * p1 + t * p2;
}

void main()
{
    fragColor = vec4(0.0, 0.0, 0.0, 1.0);
}