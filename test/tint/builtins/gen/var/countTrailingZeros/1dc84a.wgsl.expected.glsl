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
ivec4 countTrailingZeros_1dc84a() {
  ivec4 arg_0 = ivec4(1);
  uvec4 v_1 = uvec4(arg_0);
  ivec4 res = ivec4(((mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u))) | (mix(uvec4(0u), uvec4(8u), equal(((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u))) | (mix(uvec4(0u), uvec4(4u), equal((((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) & uvec4(15u)), uvec4(0u))) | (mix(uvec4(0u), uvec4(2u), equal(((((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(4u), equal((((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) & uvec4(15u)), uvec4(0u)))) & uvec4(3u)), uvec4(0u))) | mix(uvec4(0u), uvec4(1u), equal((((((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(4u), equal((((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) & uvec4(15u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(2u), equal(((((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(4u), equal((((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) & uvec4(15u)), uvec4(0u)))) & uvec4(3u)), uvec4(0u)))) & uvec4(1u)), uvec4(0u))))))) + mix(uvec4(0u), uvec4(1u), equal(((((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(4u), equal((((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) & uvec4(15u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(2u), equal(((((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(4u), equal((((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) & uvec4(15u)), uvec4(0u)))) & uvec4(3u)), uvec4(0u)))), uvec4(0u)))));
  return res;
}
void main() {
  v.inner = countTrailingZeros_1dc84a();
}
//
// compute_main
//
#version 310 es

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  ivec4 inner;
} v;
ivec4 countTrailingZeros_1dc84a() {
  ivec4 arg_0 = ivec4(1);
  uvec4 v_1 = uvec4(arg_0);
  ivec4 res = ivec4(((mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u))) | (mix(uvec4(0u), uvec4(8u), equal(((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u))) | (mix(uvec4(0u), uvec4(4u), equal((((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) & uvec4(15u)), uvec4(0u))) | (mix(uvec4(0u), uvec4(2u), equal(((((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(4u), equal((((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) & uvec4(15u)), uvec4(0u)))) & uvec4(3u)), uvec4(0u))) | mix(uvec4(0u), uvec4(1u), equal((((((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(4u), equal((((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) & uvec4(15u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(2u), equal(((((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(4u), equal((((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) & uvec4(15u)), uvec4(0u)))) & uvec4(3u)), uvec4(0u)))) & uvec4(1u)), uvec4(0u))))))) + mix(uvec4(0u), uvec4(1u), equal(((((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(4u), equal((((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) & uvec4(15u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(2u), equal(((((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(4u), equal((((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v_1 >> mix(uvec4(0u), uvec4(16u), equal((v_1 & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) & uvec4(15u)), uvec4(0u)))) & uvec4(3u)), uvec4(0u)))), uvec4(0u)))));
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = countTrailingZeros_1dc84a();
}
//
// vertex_main
//
#version 310 es


struct VertexOutput {
  vec4 pos;
  ivec4 prevent_dce;
};

layout(location = 0) flat out ivec4 vertex_main_loc0_Output;
ivec4 countTrailingZeros_1dc84a() {
  ivec4 arg_0 = ivec4(1);
  uvec4 v = uvec4(arg_0);
  ivec4 res = ivec4(((mix(uvec4(0u), uvec4(16u), equal((v & uvec4(65535u)), uvec4(0u))) | (mix(uvec4(0u), uvec4(8u), equal(((v >> mix(uvec4(0u), uvec4(16u), equal((v & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u))) | (mix(uvec4(0u), uvec4(4u), equal((((v >> mix(uvec4(0u), uvec4(16u), equal((v & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v >> mix(uvec4(0u), uvec4(16u), equal((v & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) & uvec4(15u)), uvec4(0u))) | (mix(uvec4(0u), uvec4(2u), equal(((((v >> mix(uvec4(0u), uvec4(16u), equal((v & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v >> mix(uvec4(0u), uvec4(16u), equal((v & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(4u), equal((((v >> mix(uvec4(0u), uvec4(16u), equal((v & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v >> mix(uvec4(0u), uvec4(16u), equal((v & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) & uvec4(15u)), uvec4(0u)))) & uvec4(3u)), uvec4(0u))) | mix(uvec4(0u), uvec4(1u), equal((((((v >> mix(uvec4(0u), uvec4(16u), equal((v & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v >> mix(uvec4(0u), uvec4(16u), equal((v & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(4u), equal((((v >> mix(uvec4(0u), uvec4(16u), equal((v & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v >> mix(uvec4(0u), uvec4(16u), equal((v & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) & uvec4(15u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(2u), equal(((((v >> mix(uvec4(0u), uvec4(16u), equal((v & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v >> mix(uvec4(0u), uvec4(16u), equal((v & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(4u), equal((((v >> mix(uvec4(0u), uvec4(16u), equal((v & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v >> mix(uvec4(0u), uvec4(16u), equal((v & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) & uvec4(15u)), uvec4(0u)))) & uvec4(3u)), uvec4(0u)))) & uvec4(1u)), uvec4(0u))))))) + mix(uvec4(0u), uvec4(1u), equal(((((v >> mix(uvec4(0u), uvec4(16u), equal((v & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v >> mix(uvec4(0u), uvec4(16u), equal((v & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(4u), equal((((v >> mix(uvec4(0u), uvec4(16u), equal((v & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v >> mix(uvec4(0u), uvec4(16u), equal((v & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) & uvec4(15u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(2u), equal(((((v >> mix(uvec4(0u), uvec4(16u), equal((v & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v >> mix(uvec4(0u), uvec4(16u), equal((v & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(4u), equal((((v >> mix(uvec4(0u), uvec4(16u), equal((v & uvec4(65535u)), uvec4(0u)))) >> mix(uvec4(0u), uvec4(8u), equal(((v >> mix(uvec4(0u), uvec4(16u), equal((v & uvec4(65535u)), uvec4(0u)))) & uvec4(255u)), uvec4(0u)))) & uvec4(15u)), uvec4(0u)))) & uvec4(3u)), uvec4(0u)))), uvec4(0u)))));
  return res;
}
VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = VertexOutput(vec4(0.0f), ivec4(0));
  tint_symbol.pos = vec4(0.0f);
  tint_symbol.prevent_dce = countTrailingZeros_1dc84a();
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
