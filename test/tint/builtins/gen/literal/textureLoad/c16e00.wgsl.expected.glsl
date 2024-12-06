//
// fragment_main
//
#version 310 es
precision highp float;
precision highp int;


struct TintTextureUniformData {
  uint tint_builtin_value_0;
};

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  float inner;
} v;
layout(binding = 0, std140)
uniform tint_symbol_1_ubo {
  TintTextureUniformData inner;
} v_1;
uniform highp sampler2DArray arg_0;
float textureLoad_c16e00() {
  uint v_2 = min(1u, (uint(textureSize(arg_0, 0).z) - 1u));
  uint v_3 = (v_1.inner.tint_builtin_value_0 - 1u);
  uint v_4 = min(uint(1), v_3);
  uvec2 v_5 = (uvec2(textureSize(arg_0, int(v_4)).xy) - uvec2(1u));
  ivec2 v_6 = ivec2(min(uvec2(ivec2(1)), v_5));
  ivec3 v_7 = ivec3(v_6, int(v_2));
  float res = texelFetch(arg_0, v_7, int(v_4)).x;
  return res;
}
void main() {
  v.inner = textureLoad_c16e00();
}
//
// compute_main
//
#version 310 es


struct TintTextureUniformData {
  uint tint_builtin_value_0;
};

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  float inner;
} v;
layout(binding = 0, std140)
uniform tint_symbol_1_ubo {
  TintTextureUniformData inner;
} v_1;
uniform highp sampler2DArray arg_0;
float textureLoad_c16e00() {
  uint v_2 = min(1u, (uint(textureSize(arg_0, 0).z) - 1u));
  uint v_3 = (v_1.inner.tint_builtin_value_0 - 1u);
  uint v_4 = min(uint(1), v_3);
  uvec2 v_5 = (uvec2(textureSize(arg_0, int(v_4)).xy) - uvec2(1u));
  ivec2 v_6 = ivec2(min(uvec2(ivec2(1)), v_5));
  ivec3 v_7 = ivec3(v_6, int(v_2));
  float res = texelFetch(arg_0, v_7, int(v_4)).x;
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = textureLoad_c16e00();
}
//
// vertex_main
//
#version 310 es


struct TintTextureUniformData {
  uint tint_builtin_value_0;
};

struct VertexOutput {
  vec4 pos;
  float prevent_dce;
};

layout(binding = 0, std140)
uniform tint_symbol_1_1_ubo {
  TintTextureUniformData inner;
} v;
uniform highp sampler2DArray arg_0;
layout(location = 0) flat out float vertex_main_loc0_Output;
float textureLoad_c16e00() {
  uint v_1 = min(1u, (uint(textureSize(arg_0, 0).z) - 1u));
  uint v_2 = (v.inner.tint_builtin_value_0 - 1u);
  uint v_3 = min(uint(1), v_2);
  uvec2 v_4 = (uvec2(textureSize(arg_0, int(v_3)).xy) - uvec2(1u));
  ivec2 v_5 = ivec2(min(uvec2(ivec2(1)), v_4));
  ivec3 v_6 = ivec3(v_5, int(v_1));
  float res = texelFetch(arg_0, v_6, int(v_3)).x;
  return res;
}
VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = VertexOutput(vec4(0.0f), 0.0f);
  tint_symbol.pos = vec4(0.0f);
  tint_symbol.prevent_dce = textureLoad_c16e00();
  return tint_symbol;
}
void main() {
  VertexOutput v_7 = vertex_main_inner();
  gl_Position = v_7.pos;
  gl_Position.y = -(gl_Position.y);
  gl_Position.z = ((2.0f * gl_Position.z) - gl_Position.w);
  vertex_main_loc0_Output = v_7.prevent_dce;
  gl_PointSize = 1.0f;
}
