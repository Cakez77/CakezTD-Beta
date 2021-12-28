#version 460

#include "../../src/Renderer/render_types.h"
#include "functions.h"

layout(location = 0) out vec2 uv;
layout(location = 1) out vec3 outNormal;
layout(location = 2) out mat4 test;

layout(set = 0, binding = 0) readonly buffer Vertices
{
	Vertex vertex[];
};

layout(set = 0, binding = 1) uniform GlobalUBO
{
	mat4 viewProj;
};

layout(set = 2, binding = 0) uniform MaterialUBO
{
	vec4 color;
	float scale;
};

layout(set = 3, binding = 0) readonly buffer Transforms
{
	mat4 model[];
};

layout(push_constant) uniform block
{
	int transformIdx;
};

mat4 translate(mat4 m, vec3 v)
{
    mat4 result = mat4(1.0);
    result[3] = m[0] * v[0] + m[1] * v[1] + m[2] * v[2] + m[3];
    return result;
}

void main()
{
	gl_Position = viewProj * model[transformIdx] * 
	(vec4(scale, scale, scale, 1.0) *
	vec4(vertex[gl_VertexIndex].vx,
		vertex[gl_VertexIndex].vy,
		vertex[gl_VertexIndex].vz,
		1.0));

	uv = vec2(vertex[gl_VertexIndex].ux, vertex[gl_VertexIndex].uy);

	outNormal = vec3(
		vertex[gl_VertexIndex].nx,
		vertex[gl_VertexIndex].ny,
		vertex[gl_VertexIndex].nz);

	test= translate(mat4(1.0), vec3(5.0, 5.0, 1.0));
}

