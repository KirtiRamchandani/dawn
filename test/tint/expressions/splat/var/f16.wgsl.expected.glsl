#version 310 es
#extension GL_AMD_gpu_shader_half_float : require

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void unused_entry_point() {
  return;
}
void f() {
  float16_t v = (1.0hf + 2.0hf);
  f16vec2 v2 = f16vec2(v);
  f16vec3 v3 = f16vec3(v);
  f16vec4 v4 = f16vec4(v);
}

