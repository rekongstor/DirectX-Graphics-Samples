//*********************************************************
//
// Copyright (c) Microsoft. All rights reserved.
// This code is licensed under the MIT License (MIT).
// THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
// IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
// PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
//
//*********************************************************

struct VSInput
{
   float3 position    : POSITION;
   float3 normal    : NORMAL;
   float2 uv        : TEXCOORD0;
   float3 tangent    : TANGENT;
};

struct Index
{
    uint index;
};

struct PSInput
{
   float4 position    : SV_POSITION;
   float2 uv        : TEXCOORD0;
};

cbuffer cb0 : register(b0)
{
   float4x4 g_mWorldViewProj;
};


#if defined(UNINDEXED_VERTEX_INPUT)
StructuredBuffer<Index> indexBuffer : register(t1, space1);
#endif

#if defined(INDEXED_VERTEX_INPUT) || defined(UNINDEXED_VERTEX_INPUT)
StructuredBuffer<VSInput> vertexBuffer : register(t0, space1);

VSInput GetVertexAttribute(int vertexId)
{
#if defined(INDEXED_VERTEX_INPUT)
    return vertexBuffer[vertexId];
#elif defined(UNINDEXED_VERTEX_INPUT)
    return vertexBuffer[indexBuffer[vertexId].index];
#endif
};
#endif

PSInput VSMain(
//#if defined(DEFAULT_VERTEX_INPUT)
VSInput input_
#if defined(INDEXED_VERTEX_INPUT) || defined(UNINDEXED_VERTEX_INPUT)
, uint vertexId : SV_VertexID
#endif
)
{
#if defined(INDEXED_VERTEX_INPUT) || defined(UNINDEXED_VERTEX_INPUT)
    VSInput input = GetVertexAttribute(vertexId);
#elif defined(DEFAULT_VERTEX_INPUT)
    VSInput input = input_;
#endif
    
   PSInput result;

   result.position = mul(float4(input.position, 1.0f), g_mWorldViewProj);
   result.uv = input.uv;

   return result;
}
