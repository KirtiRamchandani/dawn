//
// fragment_main
//

RWByteAddressBuffer prevent_dce : register(u0);
float16_t smoothstep_586e12() {
  float16_t arg_0 = float16_t(2.0h);
  float16_t arg_1 = float16_t(4.0h);
  float16_t arg_2 = float16_t(3.0h);
  float16_t res = smoothstep(arg_0, arg_1, arg_2);
  return res;
}

void fragment_main() {
  prevent_dce.Store<float16_t>(0u, smoothstep_586e12());
}

//
// compute_main
//

RWByteAddressBuffer prevent_dce : register(u0);
float16_t smoothstep_586e12() {
  float16_t arg_0 = float16_t(2.0h);
  float16_t arg_1 = float16_t(4.0h);
  float16_t arg_2 = float16_t(3.0h);
  float16_t res = smoothstep(arg_0, arg_1, arg_2);
  return res;
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store<float16_t>(0u, smoothstep_586e12());
}

//
// vertex_main
//
struct VertexOutput {
  float4 pos;
  float16_t prevent_dce;
};

struct vertex_main_outputs {
  nointerpolation float16_t VertexOutput_prevent_dce : TEXCOORD0;
  float4 VertexOutput_pos : SV_Position;
};


float16_t smoothstep_586e12() {
  float16_t arg_0 = float16_t(2.0h);
  float16_t arg_1 = float16_t(4.0h);
  float16_t arg_2 = float16_t(3.0h);
  float16_t res = smoothstep(arg_0, arg_1, arg_2);
  return res;
}

VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = (VertexOutput)0;
  tint_symbol.pos = (0.0f).xxxx;
  tint_symbol.prevent_dce = smoothstep_586e12();
  VertexOutput v = tint_symbol;
  return v;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_1 = vertex_main_inner();
  vertex_main_outputs v_2 = {v_1.prevent_dce, v_1.pos};
  return v_2;
}

