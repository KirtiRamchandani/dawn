//
// fragment_main
//

void clamp_8b1eaa() {
  int3 res = (int(1)).xxx;
}

void fragment_main() {
  clamp_8b1eaa();
}

//
// compute_main
//

void clamp_8b1eaa() {
  int3 res = (int(1)).xxx;
}

[numthreads(1, 1, 1)]
void compute_main() {
  clamp_8b1eaa();
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


void clamp_8b1eaa() {
  int3 res = (int(1)).xxx;
}

VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = (VertexOutput)0;
  tint_symbol.pos = (0.0f).xxxx;
  clamp_8b1eaa();
  VertexOutput v = tint_symbol;
  return v;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_1 = vertex_main_inner();
  vertex_main_outputs v_2 = {v_1.pos};
  return v_2;
}

