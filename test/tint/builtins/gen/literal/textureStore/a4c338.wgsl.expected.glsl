//
// fragment_main
//
#version 310 es
precision highp float;
precision highp int;

layout(binding = 0, rgba16f) uniform highp writeonly image2D arg_0;
void textureStore_a4c338() {
  imageStore(arg_0, ivec2(uvec2(1u, 0u)), vec4(1.0f));
}
void main() {
  textureStore_a4c338();
}
//
// compute_main
//
#version 310 es

layout(binding = 0, rgba16f) uniform highp writeonly image2D arg_0;
void textureStore_a4c338() {
  imageStore(arg_0, ivec2(uvec2(1u, 0u)), vec4(1.0f));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  textureStore_a4c338();
}
