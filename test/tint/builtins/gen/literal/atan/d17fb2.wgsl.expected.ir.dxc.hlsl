//
// fragment_main
//

void atan_d17fb2() {
  float4 res = (0.78539818525314331055f).xxxx;
}

void fragment_main() {
  atan_d17fb2();
}

//
// compute_main
//

void atan_d17fb2() {
  float4 res = (0.78539818525314331055f).xxxx;
}

[numthreads(1, 1, 1)]
void compute_main() {
  atan_d17fb2();
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


void atan_d17fb2() {
  float4 res = (0.78539818525314331055f).xxxx;
}

VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = (VertexOutput)0;
  tint_symbol.pos = (0.0f).xxxx;
  atan_d17fb2();
  VertexOutput v = tint_symbol;
  return v;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_1 = vertex_main_inner();
  vertex_main_outputs v_2 = {v_1.pos};
  return v_2;
}

