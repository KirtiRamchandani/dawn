//
// fragment_main
//

RWByteAddressBuffer prevent_dce : register(u0);
TextureCubeArray<uint4> arg_1 : register(t1, space1);
SamplerState arg_2 : register(s2, space1);
uint4 textureGather_e2acac() {
  uint4 res = arg_1.GatherGreen(arg_2, float4((1.0f).xxx, float(1u)));
  return res;
}

void fragment_main() {
  prevent_dce.Store4(0u, textureGather_e2acac());
}

//
// compute_main
//

RWByteAddressBuffer prevent_dce : register(u0);
TextureCubeArray<uint4> arg_1 : register(t1, space1);
SamplerState arg_2 : register(s2, space1);
uint4 textureGather_e2acac() {
  uint4 res = arg_1.GatherGreen(arg_2, float4((1.0f).xxx, float(1u)));
  return res;
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store4(0u, textureGather_e2acac());
}

//
// vertex_main
//
struct VertexOutput {
  float4 pos;
  uint4 prevent_dce;
};

struct vertex_main_outputs {
  nointerpolation uint4 VertexOutput_prevent_dce : TEXCOORD0;
  float4 VertexOutput_pos : SV_Position;
};


TextureCubeArray<uint4> arg_1 : register(t1, space1);
SamplerState arg_2 : register(s2, space1);
uint4 textureGather_e2acac() {
  uint4 res = arg_1.GatherGreen(arg_2, float4((1.0f).xxx, float(1u)));
  return res;
}

VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = (VertexOutput)0;
  tint_symbol.pos = (0.0f).xxxx;
  tint_symbol.prevent_dce = textureGather_e2acac();
  VertexOutput v = tint_symbol;
  return v;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_1 = vertex_main_inner();
  vertex_main_outputs v_2 = {v_1.prevent_dce, v_1.pos};
  return v_2;
}

