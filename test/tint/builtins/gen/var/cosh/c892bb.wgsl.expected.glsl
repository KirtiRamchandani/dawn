//
// fragment_main
//
#version 310 es
precision highp float;
precision highp int;

void cosh_c892bb() {
  float res = 1.0f;
}
void main() {
  cosh_c892bb();
}
//
// compute_main
//
#version 310 es

void cosh_c892bb() {
  float res = 1.0f;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  cosh_c892bb();
}
//
// vertex_main
//
#version 310 es


struct VertexOutput {
  vec4 pos;
};

void cosh_c892bb() {
  float res = 1.0f;
}
VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = VertexOutput(vec4(0.0f));
  tint_symbol.pos = vec4(0.0f);
  cosh_c892bb();
  return tint_symbol;
}
void main() {
  gl_Position = vertex_main_inner().pos;
  gl_Position.y = -(gl_Position.y);
  gl_Position.z = ((2.0f * gl_Position.z) - gl_Position.w);
  gl_PointSize = 1.0f;
}
