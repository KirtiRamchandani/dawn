//
// fragment_main
//

void degrees_fafa7e() {
  float res = 57.295780181884765625f;
}

void fragment_main() {
  degrees_fafa7e();
}

//
// compute_main
//

void degrees_fafa7e() {
  float res = 57.295780181884765625f;
}

[numthreads(1, 1, 1)]
void compute_main() {
  degrees_fafa7e();
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


void degrees_fafa7e() {
  float res = 57.295780181884765625f;
}

VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = (VertexOutput)0;
  tint_symbol.pos = (0.0f).xxxx;
  degrees_fafa7e();
  VertexOutput v = tint_symbol;
  return v;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_1 = vertex_main_inner();
  vertex_main_outputs v_2 = {v_1.pos};
  return v_2;
}

