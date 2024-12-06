//
// fragment_main
//
#version 310 es
#extension GL_AMD_gpu_shader_half_float: require
precision highp float;
precision highp int;

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  int inner;
} v;
int transpose_faeb05() {
  f16mat4x2 res = f16mat4x2(f16vec2(1.0hf), f16vec2(1.0hf), f16vec2(1.0hf), f16vec2(1.0hf));
  return mix(0, 1, (res[0u].x == 0.0hf));
}
void main() {
  v.inner = transpose_faeb05();
}
//
// compute_main
//
#version 310 es
#extension GL_AMD_gpu_shader_half_float: require

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  int inner;
} v;
int transpose_faeb05() {
  f16mat4x2 res = f16mat4x2(f16vec2(1.0hf), f16vec2(1.0hf), f16vec2(1.0hf), f16vec2(1.0hf));
  return mix(0, 1, (res[0u].x == 0.0hf));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = transpose_faeb05();
}
//
// vertex_main
//
#version 310 es
#extension GL_AMD_gpu_shader_half_float: require


struct VertexOutput {
  vec4 pos;
  int prevent_dce;
};

layout(location = 0) flat out int vertex_main_loc0_Output;
int transpose_faeb05() {
  f16mat4x2 res = f16mat4x2(f16vec2(1.0hf), f16vec2(1.0hf), f16vec2(1.0hf), f16vec2(1.0hf));
  return mix(0, 1, (res[0u].x == 0.0hf));
}
VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = VertexOutput(vec4(0.0f), 0);
  tint_symbol.pos = vec4(0.0f);
  tint_symbol.prevent_dce = transpose_faeb05();
  return tint_symbol;
}
void main() {
  VertexOutput v = vertex_main_inner();
  gl_Position = v.pos;
  gl_Position.y = -(gl_Position.y);
  gl_Position.z = ((2.0f * gl_Position.z) - gl_Position.w);
  vertex_main_loc0_Output = v.prevent_dce;
  gl_PointSize = 1.0f;
}
