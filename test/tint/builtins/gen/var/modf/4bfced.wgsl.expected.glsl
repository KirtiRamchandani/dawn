//
// fragment_main
//
#version 310 es
precision highp float;
precision highp int;


struct modf_result_vec4_f32 {
  vec4 fract;
  vec4 whole;
};

void modf_4bfced() {
  vec4 arg_0 = vec4(-1.5f);
  modf_result_vec4_f32 v = modf_result_vec4_f32(vec4(0.0f), vec4(0.0f));
  v.fract = modf(arg_0, v.whole);
  modf_result_vec4_f32 res = v;
}
void main() {
  modf_4bfced();
}
//
// compute_main
//
#version 310 es


struct modf_result_vec4_f32 {
  vec4 fract;
  vec4 whole;
};

void modf_4bfced() {
  vec4 arg_0 = vec4(-1.5f);
  modf_result_vec4_f32 v = modf_result_vec4_f32(vec4(0.0f), vec4(0.0f));
  v.fract = modf(arg_0, v.whole);
  modf_result_vec4_f32 res = v;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  modf_4bfced();
}
//
// vertex_main
//
#version 310 es


struct modf_result_vec4_f32 {
  vec4 fract;
  vec4 whole;
};

struct VertexOutput {
  vec4 pos;
};

void modf_4bfced() {
  vec4 arg_0 = vec4(-1.5f);
  modf_result_vec4_f32 v = modf_result_vec4_f32(vec4(0.0f), vec4(0.0f));
  v.fract = modf(arg_0, v.whole);
  modf_result_vec4_f32 res = v;
}
VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = VertexOutput(vec4(0.0f));
  tint_symbol.pos = vec4(0.0f);
  modf_4bfced();
  return tint_symbol;
}
void main() {
  gl_Position = vertex_main_inner().pos;
  gl_Position.y = -(gl_Position.y);
  gl_Position.z = ((2.0f * gl_Position.z) - gl_Position.w);
  gl_PointSize = 1.0f;
}
