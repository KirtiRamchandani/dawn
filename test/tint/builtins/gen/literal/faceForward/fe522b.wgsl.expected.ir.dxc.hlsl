//
// fragment_main
//

void faceForward_fe522b() {
  float3 res = (-1.0f).xxx;
}

void fragment_main() {
  faceForward_fe522b();
}

//
// compute_main
//

void faceForward_fe522b() {
  float3 res = (-1.0f).xxx;
}

[numthreads(1, 1, 1)]
void compute_main() {
  faceForward_fe522b();
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


void faceForward_fe522b() {
  float3 res = (-1.0f).xxx;
}

VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = (VertexOutput)0;
  tint_symbol.pos = (0.0f).xxxx;
  faceForward_fe522b();
  VertexOutput v = tint_symbol;
  return v;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_1 = vertex_main_inner();
  vertex_main_outputs v_2 = {v_1.pos};
  return v_2;
}

