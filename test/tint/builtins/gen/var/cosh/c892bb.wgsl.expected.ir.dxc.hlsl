//
// fragment_main
//

void cosh_c892bb() {
  float res = 1.0f;
}

void fragment_main() {
  cosh_c892bb();
}

//
// compute_main
//

void cosh_c892bb() {
  float res = 1.0f;
}

[numthreads(1, 1, 1)]
void compute_main() {
  cosh_c892bb();
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


void cosh_c892bb() {
  float res = 1.0f;
}

VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = (VertexOutput)0;
  tint_symbol.pos = (0.0f).xxxx;
  cosh_c892bb();
  VertexOutput v = tint_symbol;
  return v;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_1 = vertex_main_inner();
  vertex_main_outputs v_2 = {v_1.pos};
  return v_2;
}

