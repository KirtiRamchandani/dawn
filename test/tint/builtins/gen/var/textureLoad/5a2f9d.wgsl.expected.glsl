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
  ivec4 inner;
} v;
layout(binding = 0, std140)
uniform tint_symbol_1_ubo {
  TintTextureUniformData inner;
} v_1;
uniform highp isampler2D arg_0;
ivec4 textureLoad_5a2f9d() {
  int arg_1 = 1;
  int arg_2 = 1;
  int v_2 = arg_1;
  uint v_3 = (v_1.inner.tint_builtin_value_0 - 1u);
  uint v_4 = min(uint(arg_2), v_3);
  uint v_5 = (uvec2(textureSize(arg_0, int(v_4))).x - 1u);
  ivec2 v_6 = ivec2(uvec2(min(uint(v_2), v_5), 0u));
  ivec4 res = texelFetch(arg_0, v_6, int(v_4));
  return res;
}
void main() {
  v.inner = textureLoad_5a2f9d();
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
  ivec4 inner;
} v;
layout(binding = 0, std140)
uniform tint_symbol_1_ubo {
  TintTextureUniformData inner;
} v_1;
uniform highp isampler2D arg_0;
ivec4 textureLoad_5a2f9d() {
  int arg_1 = 1;
  int arg_2 = 1;
  int v_2 = arg_1;
  uint v_3 = (v_1.inner.tint_builtin_value_0 - 1u);
  uint v_4 = min(uint(arg_2), v_3);
  uint v_5 = (uvec2(textureSize(arg_0, int(v_4))).x - 1u);
  ivec2 v_6 = ivec2(uvec2(min(uint(v_2), v_5), 0u));
  ivec4 res = texelFetch(arg_0, v_6, int(v_4));
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = textureLoad_5a2f9d();
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
  ivec4 prevent_dce;
};

layout(binding = 0, std140)
uniform tint_symbol_1_1_ubo {
  TintTextureUniformData inner;
} v;
uniform highp isampler2D arg_0;
layout(location = 0) flat out ivec4 vertex_main_loc0_Output;
ivec4 textureLoad_5a2f9d() {
  int arg_1 = 1;
  int arg_2 = 1;
  int v_1 = arg_1;
  uint v_2 = (v.inner.tint_builtin_value_0 - 1u);
  uint v_3 = min(uint(arg_2), v_2);
  uint v_4 = (uvec2(textureSize(arg_0, int(v_3))).x - 1u);
  ivec2 v_5 = ivec2(uvec2(min(uint(v_1), v_4), 0u));
  ivec4 res = texelFetch(arg_0, v_5, int(v_3));
  return res;
}
VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = VertexOutput(vec4(0.0f), ivec4(0));
  tint_symbol.pos = vec4(0.0f);
  tint_symbol.prevent_dce = textureLoad_5a2f9d();
  return tint_symbol;
}
void main() {
  VertexOutput v_6 = vertex_main_inner();
  gl_Position = v_6.pos;
  gl_Position.y = -(gl_Position.y);
  gl_Position.z = ((2.0f * gl_Position.z) - gl_Position.w);
  vertex_main_loc0_Output = v_6.prevent_dce;
  gl_PointSize = 1.0f;
}
