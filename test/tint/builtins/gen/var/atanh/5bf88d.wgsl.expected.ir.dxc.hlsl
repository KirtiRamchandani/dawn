//
// fragment_main
//

RWByteAddressBuffer prevent_dce : register(u0);
vector<float16_t, 2> atanh_5bf88d() {
  vector<float16_t, 2> arg_0 = (float16_t(0.5h)).xx;
  vector<float16_t, 2> v = arg_0;
  vector<float16_t, 2> res = (log((((float16_t(1.0h)).xx + v) / ((float16_t(1.0h)).xx - v))) * (float16_t(0.5h)).xx);
  return res;
}

void fragment_main() {
  prevent_dce.Store<vector<float16_t, 2> >(0u, atanh_5bf88d());
}

//
// compute_main
//

RWByteAddressBuffer prevent_dce : register(u0);
vector<float16_t, 2> atanh_5bf88d() {
  vector<float16_t, 2> arg_0 = (float16_t(0.5h)).xx;
  vector<float16_t, 2> v = arg_0;
  vector<float16_t, 2> res = (log((((float16_t(1.0h)).xx + v) / ((float16_t(1.0h)).xx - v))) * (float16_t(0.5h)).xx);
  return res;
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store<vector<float16_t, 2> >(0u, atanh_5bf88d());
}

//
// vertex_main
//
struct VertexOutput {
  float4 pos;
  vector<float16_t, 2> prevent_dce;
};

struct vertex_main_outputs {
  nointerpolation vector<float16_t, 2> VertexOutput_prevent_dce : TEXCOORD0;
  float4 VertexOutput_pos : SV_Position;
};


vector<float16_t, 2> atanh_5bf88d() {
  vector<float16_t, 2> arg_0 = (float16_t(0.5h)).xx;
  vector<float16_t, 2> v = arg_0;
  vector<float16_t, 2> res = (log((((float16_t(1.0h)).xx + v) / ((float16_t(1.0h)).xx - v))) * (float16_t(0.5h)).xx);
  return res;
}

VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = (VertexOutput)0;
  tint_symbol.pos = (0.0f).xxxx;
  tint_symbol.prevent_dce = atanh_5bf88d();
  VertexOutput v_1 = tint_symbol;
  return v_1;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_2 = vertex_main_inner();
  vertex_main_outputs v_3 = {v_2.prevent_dce, v_2.pos};
  return v_3;
}

