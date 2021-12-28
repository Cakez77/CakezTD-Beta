#version 450

layout(location = 0) in vec2 uv;
layout(location = 1) in vec3 normal;

layout(location = 0) out vec4 fragColor;

layout(set = 1, binding = 0) uniform sampler2D diffuse;

layout(set = 2, binding = 0) uniform MaterialUBO
{
	vec4 color;
    float scale;
};

void main(){
    fragColor = color * texture(diffuse, uv);
}