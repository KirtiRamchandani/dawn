//
// fragment_main
//

RWByteAddressBuffer prevent_dce : register(u0);
int2 bitcast_214f23() {
  int2 res = (int(1006648320)).xx;
  return res;
}

void fragment_main() {
  prevent_dce.Store2(0u, asuint(bitcast_214f23()));
}

//
// compute_main
//

RWByteAddressBuffer prevent_dce : register(u0);
int2 bitcast_214f23() {
  int2 res = (int(1006648320)).xx;
  return res;
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store2(0u, asuint(bitcast_214f23()));
}

//
// vertex_main
//
struct VertexOutput {
  float4 pos;
  int2 prevent_dce;
};

struct vertex_main_outputs {
  nointerpolation int2 VertexOutput_prevent_dce : TEXCOORD0;
  float4 VertexOutput_pos : SV_Position;
};


int2 bitcast_214f23() {
  int2 res = (int(1006648320)).xx;
  return res;
}

VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = (VertexOutput)0;
  tint_symbol.pos = (0.0f).xxxx;
  tint_symbol.prevent_dce = bitcast_214f23();
  VertexOutput v = tint_symbol;
  return v;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_1 = vertex_main_inner();
  vertex_main_outputs v_2 = {v_1.prevent_dce, v_1.pos};
  return v_2;
}

