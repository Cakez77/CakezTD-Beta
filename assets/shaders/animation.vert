#version 460

#include "../../src/Renderer/shared_render_types.h"

layout(location = 0) out vec2 uv;
layout(location = 1) out uint materialIdx;

layout(set = 0, binding = 0) readonly buffer SpriteTransforms
{
    Transform transforms[];
};

layout(set = 0, binding = 1) uniform GlobalUBO
{
    GlobalData globalData;
};

layout(set = 1, binding = 0) uniform sampler2D sprite;

layout(push_constant) uniform block
{
    PushData pushData;
};



void main()
{
    Transform transform = transforms[pushData.transformIdx + gl_InstanceIndex];

    // Calcualte SUB UV Sizes
    vec2 textSize = textureSize(sprite, 0);
    float normU = pushData.subrectWidth/textSize.x;
    float normV = pushData.subrectHeight/textSize.y;
    int cols = int(textSize.x/pushData.subrectWidth);
    int rows = int(textSize.y/pushData.subrectHeight);

    // UV Rect 
    float top = int(transform.animationIdx/cols) * normV;
    float left = mod(transform.animationIdx, cols) * normU;
    float bottom = top + normV;
    float right = left + normU;

    bool flip = transform.u == 1.0;

    // Screeen Size
    vec2 screenSize = globalData.screenSize;

    vec4 positions[4] = vec4[](
        // top left
        vec4(
        transform.position.x,
        transform.position.y,
        flip? right : left,
        top
        ),

        // bottom left
        vec4(
        transform.position.x,
        transform.position.y + transform.position.w,
        flip? right: left,
        bottom
        ),

        // bottom right
        vec4(
        transform.position.x + transform.position.z,
        transform.position.y + transform.position.w,
        flip? left : right,
        bottom
        ),

        // top right
        vec4(
        transform.position.x + transform.position.z,
        transform.position.y,
        flip? left : right,
        top
        )
    );
    vec2 normalizedPos = 2.0 * positions[gl_VertexIndex].xy / screenSize - 1.0;
    gl_Position = vec4(normalizedPos, transform.layer, 1.0);

    uv = positions[gl_VertexIndex].zw;
    materialIdx = transform.materialIdx;
}