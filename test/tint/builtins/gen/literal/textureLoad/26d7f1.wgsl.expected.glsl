//
// fragment_main
//
#version 460
precision highp float;
precision highp int;

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  uvec4 inner;
} v;
layout(binding = 0, rg32ui) uniform highp readonly uimage2DArray arg_0;
uvec4 textureLoad_26d7f1() {
  uint v_1 = (uint(imageSize(arg_0).z) - 1u);
  uint v_2 = min(uint(1), v_1);
  ivec2 v_3 = ivec2(min(uvec2(1u), (uvec2(imageSize(arg_0).xy) - uvec2(1u))));
  uvec4 res = imageLoad(arg_0, ivec3(v_3, int(v_2)));
  return res;
}
void main() {
  v.inner = textureLoad_26d7f1();
}
//
// compute_main
//
#version 460

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  uvec4 inner;
} v;
layout(binding = 0, rg32ui) uniform highp readonly uimage2DArray arg_0;
uvec4 textureLoad_26d7f1() {
  uint v_1 = (uint(imageSize(arg_0).z) - 1u);
  uint v_2 = min(uint(1), v_1);
  ivec2 v_3 = ivec2(min(uvec2(1u), (uvec2(imageSize(arg_0).xy) - uvec2(1u))));
  uvec4 res = imageLoad(arg_0, ivec3(v_3, int(v_2)));
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = textureLoad_26d7f1();
}
//
// vertex_main
//
#version 460


struct VertexOutput {
  vec4 pos;
  uvec4 prevent_dce;
};

layout(binding = 0, rg32ui) uniform highp readonly uimage2DArray arg_0;
layout(location = 0) flat out uvec4 vertex_main_loc0_Output;
uvec4 textureLoad_26d7f1() {
  uint v = (uint(imageSize(arg_0).z) - 1u);
  uint v_1 = min(uint(1), v);
  ivec2 v_2 = ivec2(min(uvec2(1u), (uvec2(imageSize(arg_0).xy) - uvec2(1u))));
  uvec4 res = imageLoad(arg_0, ivec3(v_2, int(v_1)));
  return res;
}
VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = VertexOutput(vec4(0.0f), uvec4(0u));
  tint_symbol.pos = vec4(0.0f);
  tint_symbol.prevent_dce = textureLoad_26d7f1();
  return tint_symbol;
}
void main() {
  VertexOutput v_3 = vertex_main_inner();
  gl_Position = v_3.pos;
  gl_Position.y = -(gl_Position.y);
  gl_Position.z = ((2.0f * gl_Position.z) - gl_Position.w);
  vertex_main_loc0_Output = v_3.prevent_dce;
  gl_PointSize = 1.0f;
}
