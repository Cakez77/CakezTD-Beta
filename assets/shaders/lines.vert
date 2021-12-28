#version 450

#include "../../src/Renderer/shared_render_types.h"

layout(set = 0, binding = 0) readonly buffer SpriteTransforms
{
    Transform transforms[];
};

layout(set = 0, binding = 1) uniform GlobalUBO
{
    GlobalData globalData;
};

layout(push_constant) uniform block
{
    PushData pushData;
};


Transform transform = transforms[pushData.transformIdx + gl_InstanceIndex];

vec2 positions[2] = vec2[]
(
    // Start Pos
    transform.position.xy,

    // End Pos
    transform.position.zw
);

void main()
{
    vec2 normalizedPos = (2.0 * positions[gl_VertexIndex] / globalData.screenSize) - 1.0;

    gl_Position = vec4(normalizedPos, 0.9, 1.0);
}