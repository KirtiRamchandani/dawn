#version 460

uniform highp samplerCubeArrayShadow t_f;
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  uvec2 dims = uvec2(textureSize(t_f, 0).xy);
}
