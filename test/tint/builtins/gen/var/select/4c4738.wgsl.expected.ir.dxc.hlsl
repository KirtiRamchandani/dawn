//
// fragment_main
//

void select_4c4738() {
  bool4 arg_2 = (true).xxxx;
  int4 res = ((arg_2) ? ((int(1)).xxxx) : ((int(1)).xxxx));
}

void fragment_main() {
  select_4c4738();
}

//
// compute_main
//

void select_4c4738() {
  bool4 arg_2 = (true).xxxx;
  int4 res = ((arg_2) ? ((int(1)).xxxx) : ((int(1)).xxxx));
}

[numthreads(1, 1, 1)]
void compute_main() {
  select_4c4738();
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


void select_4c4738() {
  bool4 arg_2 = (true).xxxx;
  int4 res = ((arg_2) ? ((int(1)).xxxx) : ((int(1)).xxxx));
}

VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = (VertexOutput)0;
  tint_symbol.pos = (0.0f).xxxx;
  select_4c4738();
  VertexOutput v = tint_symbol;
  return v;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_1 = vertex_main_inner();
  vertex_main_outputs v_2 = {v_1.pos};
  return v_2;
}

