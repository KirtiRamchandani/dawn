//
// fragment_main
//

void transpose_70ca11() {
  float3x2 res = float3x2((1.0f).xx, (1.0f).xx, (1.0f).xx);
}

void fragment_main() {
  transpose_70ca11();
}

//
// compute_main
//

void transpose_70ca11() {
  float3x2 res = float3x2((1.0f).xx, (1.0f).xx, (1.0f).xx);
}

[numthreads(1, 1, 1)]
void compute_main() {
  transpose_70ca11();
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


void transpose_70ca11() {
  float3x2 res = float3x2((1.0f).xx, (1.0f).xx, (1.0f).xx);
}

VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = (VertexOutput)0;
  tint_symbol.pos = (0.0f).xxxx;
  transpose_70ca11();
  VertexOutput v = tint_symbol;
  return v;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_1 = vertex_main_inner();
  vertex_main_outputs v_2 = {v_1.pos};
  return v_2;
}

