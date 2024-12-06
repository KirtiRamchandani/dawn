//
// fragment_main
//
#version 310 es
precision highp float;
precision highp int;

void select_4c4738() {
  bvec4 arg_2 = bvec4(true);
  ivec4 res = mix(ivec4(1), ivec4(1), arg_2);
}
void main() {
  select_4c4738();
}
//
// compute_main
//
#version 310 es

void select_4c4738() {
  bvec4 arg_2 = bvec4(true);
  ivec4 res = mix(ivec4(1), ivec4(1), arg_2);
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  select_4c4738();
}
//
// vertex_main
//
#version 310 es


struct VertexOutput {
  vec4 pos;
};

void select_4c4738() {
  bvec4 arg_2 = bvec4(true);
  ivec4 res = mix(ivec4(1), ivec4(1), arg_2);
}
VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = VertexOutput(vec4(0.0f));
  tint_symbol.pos = vec4(0.0f);
  select_4c4738();
  return tint_symbol;
}
void main() {
  gl_Position = vertex_main_inner().pos;
  gl_Position.y = -(gl_Position.y);
  gl_Position.z = ((2.0f * gl_Position.z) - gl_Position.w);
  gl_PointSize = 1.0f;
}
