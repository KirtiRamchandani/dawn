//
// fragment_main
//

void fract_2eddfe() {
  float res = 0.25f;
}

void fragment_main() {
  fract_2eddfe();
}

//
// compute_main
//

void fract_2eddfe() {
  float res = 0.25f;
}

[numthreads(1, 1, 1)]
void compute_main() {
  fract_2eddfe();
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


void fract_2eddfe() {
  float res = 0.25f;
}

VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = (VertexOutput)0;
  tint_symbol.pos = (0.0f).xxxx;
  fract_2eddfe();
  VertexOutput v = tint_symbol;
  return v;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_1 = vertex_main_inner();
  vertex_main_outputs v_2 = {v_1.pos};
  return v_2;
}

