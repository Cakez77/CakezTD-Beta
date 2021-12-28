#version 450

#include "../../src/Renderer/shared_render_types.h"

// Data from vertex shader
layout(location = 0) in vec2 uv;
layout(location = 1) in float radius;
layout(location = 2) in flat uint materialIdx;
layout(location = 3) in flat vec2 circleMiddle;

// Output 
layout(location = 0) out vec4 fragColor;

// Material
layout(set = 0, binding = 2) readonly buffer MaterialSBO
{
    MaterialData materials[];
};

// Textures
layout(set = 1, binding = 0) uniform sampler2D mask[];
layout(set = 1, binding = 1) uniform sampler2D sprite;


void main()
{
    vec4 color = texture(sprite, uv);
    // Draw circle
    if(radius > 0)
    {
        if(length(circleMiddle - gl_FragCoord.xy) > radius)
        {
            discard;
        }
        else if(length(circleMiddle - gl_FragCoord.xy) > radius - 2.0)
        {
            // Black Border
            color = vec4(0.0, 0.0, 0.0, 0.5);
        }
        else
        {
            // Transparent Circle
            color.a *= 0.2;
        }
    }
    else // Draw normal sprite
    {
        MaterialData material = materials[materialIdx];

        int alpha = int(round(color.a * 255));
        if(color.a == 0.0)
        {
            discard;
        }
        else if(alpha <= COLOR_COUNT)
        {
            color = vec4(material.color.rgb * (1.0 - alpha * (1.0 / COLOR_COUNT)), 1.0);
        }
        else
        {
            color = color* material.color;
        }
        // float distanceToLight = 1.0 - length(vec2(0.0, 0.0) - pos) / 2000.0;
        // distanceToLight = pow(distanceToLight, 3);
        // fragColor = vec4(distanceToLight, distanceToLight, distanceToLight, color.a);
        // fragColor = vec4(color.rgb*distanceToLight, color.a);
    }

    fragColor = color;
}