//
// fragment_main
//

void step_38cd79() {
  float4 res = (1.0f).xxxx;
}

void fragment_main() {
  step_38cd79();
}

//
// compute_main
//

void step_38cd79() {
  float4 res = (1.0f).xxxx;
}

[numthreads(1, 1, 1)]
void compute_main() {
  step_38cd79();
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


void step_38cd79() {
  float4 res = (1.0f).xxxx;
}

VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = (VertexOutput)0;
  tint_symbol.pos = (0.0f).xxxx;
  step_38cd79();
  VertexOutput v = tint_symbol;
  return v;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_1 = vertex_main_inner();
  vertex_main_outputs v_2 = {v_1.pos};
  return v_2;
}

