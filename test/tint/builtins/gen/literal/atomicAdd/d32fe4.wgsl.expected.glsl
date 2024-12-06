//
// fragment_main
//
#version 310 es
precision highp float;
precision highp int;


struct SB_RW {
  int arg_0;
};

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  int inner;
} v;
layout(binding = 1, std430)
buffer sb_rw_block_1_ssbo {
  SB_RW inner;
} v_1;
int atomicAdd_d32fe4() {
  int res = atomicAdd(v_1.inner.arg_0, 1);
  return res;
}
void main() {
  v.inner = atomicAdd_d32fe4();
}
//
// compute_main
//
#version 310 es


struct SB_RW {
  int arg_0;
};

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  int inner;
} v;
layout(binding = 1, std430)
buffer sb_rw_block_1_ssbo {
  SB_RW inner;
} v_1;
int atomicAdd_d32fe4() {
  int res = atomicAdd(v_1.inner.arg_0, 1);
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = atomicAdd_d32fe4();
}
