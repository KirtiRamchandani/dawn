//
// fragment_main
//
#version 310 es
precision highp float;
precision highp int;

layout(binding = 0, r32i) uniform highp writeonly iimage3D arg_0;
void textureStore_f1e6d3() {
  imageStore(arg_0, ivec3(uvec3(1u)), ivec4(1));
}
void main() {
  textureStore_f1e6d3();
}
//
// compute_main
//
#version 310 es

layout(binding = 0, r32i) uniform highp writeonly iimage3D arg_0;
void textureStore_f1e6d3() {
  imageStore(arg_0, ivec3(uvec3(1u)), ivec4(1));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  textureStore_f1e6d3();
}
