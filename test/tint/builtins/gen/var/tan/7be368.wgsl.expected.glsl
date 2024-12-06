//
// fragment_main
//
#version 310 es
precision highp float;
precision highp int;

void tan_7be368() {
  vec2 res = vec2(1.55740773677825927734f);
}
void main() {
  tan_7be368();
}
//
// compute_main
//
#version 310 es

void tan_7be368() {
  vec2 res = vec2(1.55740773677825927734f);
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  tan_7be368();
}
//
// vertex_main
//
#version 310 es


struct VertexOutput {
  vec4 pos;
};

void tan_7be368() {
  vec2 res = vec2(1.55740773677825927734f);
}
VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = VertexOutput(vec4(0.0f));
  tint_symbol.pos = vec4(0.0f);
  tan_7be368();
  return tint_symbol;
}
void main() {
  gl_Position = vertex_main_inner().pos;
  gl_Position.y = -(gl_Position.y);
  gl_Position.z = ((2.0f * gl_Position.z) - gl_Position.w);
  gl_PointSize = 1.0f;
}
