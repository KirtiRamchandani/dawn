//
// fragment_main
//

void inverseSqrt_f60c1c() {
  float2 res = (1.0f).xx;
}

void fragment_main() {
  inverseSqrt_f60c1c();
}

//
// compute_main
//

void inverseSqrt_f60c1c() {
  float2 res = (1.0f).xx;
}

[numthreads(1, 1, 1)]
void compute_main() {
  inverseSqrt_f60c1c();
}

//
// vertex_main
//
struct VertexOutput {
  float4 pos;
};

struct vertex_main_outputs {
  float4 VertexOutput_pos : SV_Position;
};


void inverseSqrt_f60c1c() {
  float2 res = (1.0f).xx;
}

VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = (VertexOutput)0;
  tint_symbol.pos = (0.0f).xxxx;
  inverseSqrt_f60c1c();
  VertexOutput v = tint_symbol;
  return v;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_1 = vertex_main_inner();
  vertex_main_outputs v_2 = {v_1.pos};
  return v_2;
}

