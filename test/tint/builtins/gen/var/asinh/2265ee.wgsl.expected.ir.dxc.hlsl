//
// fragment_main
//

RWByteAddressBuffer prevent_dce : register(u0);
float3 asinh_2265ee() {
  float3 arg_0 = (1.0f).xxx;
  float3 v = arg_0;
  float3 res = log((v + sqrt(((v * v) + (1.0f).xxx))));
  return res;
}

void fragment_main() {
  prevent_dce.Store3(0u, asuint(asinh_2265ee()));
}

//
// compute_main
//

RWByteAddressBuffer prevent_dce : register(u0);
float3 asinh_2265ee() {
  float3 arg_0 = (1.0f).xxx;
  float3 v = arg_0;
  float3 res = log((v + sqrt(((v * v) + (1.0f).xxx))));
  return res;
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store3(0u, asuint(asinh_2265ee()));
}

//
// vertex_main
//
struct VertexOutput {
  float4 pos;
  float3 prevent_dce;
};

struct vertex_main_outputs {
  nointerpolation float3 VertexOutput_prevent_dce : TEXCOORD0;
  float4 VertexOutput_pos : SV_Position;
};


float3 asinh_2265ee() {
  float3 arg_0 = (1.0f).xxx;
  float3 v = arg_0;
  float3 res = log((v + sqrt(((v * v) + (1.0f).xxx))));
  return res;
}

VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = (VertexOutput)0;
  tint_symbol.pos = (0.0f).xxxx;
  tint_symbol.prevent_dce = asinh_2265ee();
  VertexOutput v_1 = tint_symbol;
  return v_1;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_2 = vertex_main_inner();
  vertex_main_outputs v_3 = {v_2.prevent_dce, v_2.pos};
  return v_3;
}

