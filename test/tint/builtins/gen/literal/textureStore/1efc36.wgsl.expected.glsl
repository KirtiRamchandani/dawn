//
// fragment_main
//
#version 310 es
precision highp float;
precision highp int;

layout(binding = 0, rgba16ui) uniform highp writeonly uimage3D arg_0;
void textureStore_1efc36() {
  imageStore(arg_0, ivec3(uvec3(1u)), uvec4(1u));
}
void main() {
  textureStore_1efc36();
}
//
// compute_main
//
#version 310 es

layout(binding = 0, rgba16ui) uniform highp writeonly uimage3D arg_0;
void textureStore_1efc36() {
  imageStore(arg_0, ivec3(uvec3(1u)), uvec4(1u));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  textureStore_1efc36();
}
