//
// fragment_main
//

void tan_ae26ae() {
  float3 res = (1.55740773677825927734f).xxx;
}

void fragment_main() {
  tan_ae26ae();
}

//
// compute_main
//

void tan_ae26ae() {
  float3 res = (1.55740773677825927734f).xxx;
}

[numthreads(1, 1, 1)]
void compute_main() {
  tan_ae26ae();
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


void tan_ae26ae() {
  float3 res = (1.55740773677825927734f).xxx;
}

VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = (VertexOutput)0;
  tint_symbol.pos = (0.0f).xxxx;
  tan_ae26ae();
  VertexOutput v = tint_symbol;
  return v;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_1 = vertex_main_inner();
  vertex_main_outputs v_2 = {v_1.pos};
  return v_2;
}

