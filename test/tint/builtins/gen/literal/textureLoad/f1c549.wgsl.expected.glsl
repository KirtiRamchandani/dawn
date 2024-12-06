//
// fragment_main
//
#version 310 es
precision highp float;
precision highp int;

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  vec4 inner;
} v;
layout(binding = 0, r32f) uniform highp image3D arg_0;
vec4 textureLoad_f1c549() {
  uvec3 v_1 = (uvec3(imageSize(arg_0)) - uvec3(1u));
  vec4 res = imageLoad(arg_0, ivec3(min(uvec3(ivec3(1)), v_1)));
  return res;
}
void main() {
  v.inner = textureLoad_f1c549();
}
//
// compute_main
//
#version 310 es

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  vec4 inner;
} v;
layout(binding = 0, r32f) uniform highp image3D arg_0;
vec4 textureLoad_f1c549() {
  uvec3 v_1 = (uvec3(imageSize(arg_0)) - uvec3(1u));
  vec4 res = imageLoad(arg_0, ivec3(min(uvec3(ivec3(1)), v_1)));
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = textureLoad_f1c549();
}
