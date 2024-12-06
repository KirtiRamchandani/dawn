//
// fragment_main
//
#version 310 es
precision highp float;
precision highp int;

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  ivec4 inner;
} v;
uniform highp isampler2DMS arg_0;
ivec4 textureLoad_7bee94() {
  ivec2 v_1 = ivec2(min(uvec2(1u), (uvec2(textureSize(arg_0)) - uvec2(1u))));
  ivec4 res = texelFetch(arg_0, v_1, int(1));
  return res;
}
void main() {
  v.inner = textureLoad_7bee94();
}
//
// compute_main
//
#version 310 es

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  ivec4 inner;
} v;
uniform highp isampler2DMS arg_0;
ivec4 textureLoad_7bee94() {
  ivec2 v_1 = ivec2(min(uvec2(1u), (uvec2(textureSize(arg_0)) - uvec2(1u))));
  ivec4 res = texelFetch(arg_0, v_1, int(1));
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = textureLoad_7bee94();
}
//
// vertex_main
//
#version 310 es


struct VertexOutput {
  vec4 pos;
  ivec4 prevent_dce;
};

uniform highp isampler2DMS arg_0;
layout(location = 0) flat out ivec4 vertex_main_loc0_Output;
ivec4 textureLoad_7bee94() {
  ivec2 v = ivec2(min(uvec2(1u), (uvec2(textureSize(arg_0)) - uvec2(1u))));
  ivec4 res = texelFetch(arg_0, v, int(1));
  return res;
}
VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = VertexOutput(vec4(0.0f), ivec4(0));
  tint_symbol.pos = vec4(0.0f);
  tint_symbol.prevent_dce = textureLoad_7bee94();
  return tint_symbol;
}
void main() {
  VertexOutput v_1 = vertex_main_inner();
  gl_Position = v_1.pos;
  gl_Position.y = -(gl_Position.y);
  gl_Position.z = ((2.0f * gl_Position.z) - gl_Position.w);
  vertex_main_loc0_Output = v_1.prevent_dce;
  gl_PointSize = 1.0f;
}
