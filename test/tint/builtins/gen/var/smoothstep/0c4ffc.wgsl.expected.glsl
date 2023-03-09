#version 310 es

void smoothstep_0c4ffc() {
  vec4 res = vec4(0.5f);
}

vec4 vertex_main() {
  smoothstep_0c4ffc();
  return vec4(0.0f);
}

void main() {
  gl_PointSize = 1.0;
  vec4 inner_result = vertex_main();
  gl_Position = inner_result;
  gl_Position.y = -(gl_Position.y);
  gl_Position.z = ((2.0f * gl_Position.z) - gl_Position.w);
  return;
}
#version 310 es
precision highp float;

void smoothstep_0c4ffc() {
  vec4 res = vec4(0.5f);
}

void fragment_main() {
  smoothstep_0c4ffc();
}

void main() {
  fragment_main();
  return;
}
#version 310 es

void smoothstep_0c4ffc() {
  vec4 res = vec4(0.5f);
}

void compute_main() {
  smoothstep_0c4ffc();
}

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  compute_main();
  return;
}
