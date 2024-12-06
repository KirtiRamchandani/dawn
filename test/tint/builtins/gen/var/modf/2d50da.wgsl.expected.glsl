//
// fragment_main
//
#version 310 es
precision highp float;
precision highp int;


struct modf_result_vec2_f32 {
  vec2 fract;
  vec2 whole;
};

void modf_2d50da() {
  vec2 arg_0 = vec2(-1.5f);
  modf_result_vec2_f32 v = modf_result_vec2_f32(vec2(0.0f), vec2(0.0f));
  v.fract = modf(arg_0, v.whole);
  modf_result_vec2_f32 res = v;
}
void main() {
  modf_2d50da();
}
//
// compute_main
//
#version 310 es


struct modf_result_vec2_f32 {
  vec2 fract;
  vec2 whole;
};

void modf_2d50da() {
  vec2 arg_0 = vec2(-1.5f);
  modf_result_vec2_f32 v = modf_result_vec2_f32(vec2(0.0f), vec2(0.0f));
  v.fract = modf(arg_0, v.whole);
  modf_result_vec2_f32 res = v;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  modf_2d50da();
}
//
// vertex_main
//
#version 310 es


struct modf_result_vec2_f32 {
  vec2 fract;
  vec2 whole;
};

struct VertexOutput {
  vec4 pos;
};

void modf_2d50da() {
  vec2 arg_0 = vec2(-1.5f);
  modf_result_vec2_f32 v = modf_result_vec2_f32(vec2(0.0f), vec2(0.0f));
  v.fract = modf(arg_0, v.whole);
  modf_result_vec2_f32 res = v;
}
VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = VertexOutput(vec4(0.0f));
  tint_symbol.pos = vec4(0.0f);
  modf_2d50da();
  return tint_symbol;
}
void main() {
  gl_Position = vertex_main_inner().pos;
  gl_Position.y = -(gl_Position.y);
  gl_Position.z = ((2.0f * gl_Position.z) - gl_Position.w);
  gl_PointSize = 1.0f;
}
