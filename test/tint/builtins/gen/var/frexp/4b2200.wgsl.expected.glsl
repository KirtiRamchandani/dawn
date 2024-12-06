//
// fragment_main
//
#version 310 es
precision highp float;
precision highp int;


struct frexp_result_f32 {
  float fract;
  int exp;
};

void frexp_4b2200() {
  float arg_0 = 1.0f;
  frexp_result_f32 v = frexp_result_f32(0.0f, 0);
  v.fract = frexp(arg_0, v.exp);
  frexp_result_f32 res = v;
}
void main() {
  frexp_4b2200();
}
//
// compute_main
//
#version 310 es


struct frexp_result_f32 {
  float fract;
  int exp;
};

void frexp_4b2200() {
  float arg_0 = 1.0f;
  frexp_result_f32 v = frexp_result_f32(0.0f, 0);
  v.fract = frexp(arg_0, v.exp);
  frexp_result_f32 res = v;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  frexp_4b2200();
}
//
// vertex_main
//
#version 310 es


struct frexp_result_f32 {
  float fract;
  int exp;
};

struct VertexOutput {
  vec4 pos;
};

void frexp_4b2200() {
  float arg_0 = 1.0f;
  frexp_result_f32 v = frexp_result_f32(0.0f, 0);
  v.fract = frexp(arg_0, v.exp);
  frexp_result_f32 res = v;
}
VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = VertexOutput(vec4(0.0f));
  tint_symbol.pos = vec4(0.0f);
  frexp_4b2200();
  return tint_symbol;
}
void main() {
  gl_Position = vertex_main_inner().pos;
  gl_Position.y = -(gl_Position.y);
  gl_Position.z = ((2.0f * gl_Position.z) - gl_Position.w);
  gl_PointSize = 1.0f;
}
