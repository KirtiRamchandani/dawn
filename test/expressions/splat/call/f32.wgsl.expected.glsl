#version 310 es
precision mediump float;

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void unused_entry_point() {
  return;
}
void main() {
  unused_entry_point();
}



float get_f32() {
  return 1.0f;
}

void f() {
  vec2 v2 = vec2(get_f32());
  vec3 v3 = vec3(get_f32());
  vec4 v4 = vec4(get_f32());
}
