//
//  Shader.metal
//  HelloMetal
//
//  Created by David Garcia on 12/16/17.
//  Copyright © 2017 David Garcia. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn{
	packed_float3 position;
	packed_float4 color;
};

struct VertexOut{
	float4 position [[position]];
	float4 color;
};

struct Uniforms{
	float4x4 modelMatrix;
	float4x4 projectionMatrix;
};
vertex VertexOut basic_vertex(const device VertexIn* vertex_array [[ buffer(0)]],
							  const device Uniforms& uniforms [[buffer(1)]],
							  unsigned int vid [[ vertex_id]])
{
	float4x4 proj_Matrix = uniforms.projectionMatrix;
	float4x4 mv_Matrix = uniforms.modelMatrix;
	
	VertexIn VertexIn = vertex_array[vid];
	
	VertexOut VertexOut;
	VertexOut.position = proj_Matrix * mv_Matrix * float4(VertexIn.position,1);
	VertexOut.color = VertexIn.color;
	
	return VertexOut;
}

fragment half4 basic_fragment(VertexOut intrepolated [[stage_in]]) {
	return half4(intrepolated.color[0], intrepolated.color[1], intrepolated.color[2], intrepolated.color[3]);
}
