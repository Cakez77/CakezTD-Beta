#version 460

#include "../../src/Renderer/shared_render_types.h"

layout(location = 0) out vec2 uv;
layout(location = 1) out float radius;
layout(location = 2) out uint materialIdx;
layout(location = 3) out vec2 circleMiddle;

layout(set = 0, binding = 0) readonly buffer SpriteTransforms
{
    Transform transforms[];
};

layout(set = 0, binding = 1) uniform GlobalUBO
{
    GlobalData globalData;
};

layout(set = 1, binding = 1) uniform sampler2D sprite;

// Push Constants
layout(push_constant) uniform block
{
    PushData pushData;
};

// Transform data
Transform transform = transforms[pushData.transformIdx + gl_InstanceIndex];

// Vertices
vec4 positions[4] = vec4[](
    // top left
    vec4(
        transform.position.x,
        transform.position.y,
        0.0,
        0.0
    ),

    // bottom left
    vec4(
        transform.position.x,
        transform.position.y + transform.position.w,
        0.0,
        1.0
    ),

    // bottom right
    vec4(
        transform.position.x + transform.position.z,
        transform.position.y + transform.position.w,
        1.0,
        1.0
    ),

    // top right
    vec4(
        transform.position.x + transform.position.z,
        transform.position.y,
        1.0,
        0.0
    )
);

void main()
{
    vec2 screenSize = globalData.screenSize;
    vec2 normalizedPos = (2 * positions[gl_VertexIndex].xy / screenSize) - 1.0;
    gl_Position = vec4(normalizedPos, transform.layer, 1.0);

    uv = positions[gl_VertexIndex].zw;
    radius = transform.radius;
    materialIdx = transform.materialIdx;
    circleMiddle = vec2(transform.position.x + transform.position.z/2, transform.position.y + transform.position.w/2);
}