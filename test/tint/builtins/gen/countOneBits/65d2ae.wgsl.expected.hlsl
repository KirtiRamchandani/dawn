void countOneBits_65d2ae() {
  int3 res = asint(countbits(asuint(int3(0, 0, 0))));
}

struct tint_symbol {
  float4 value : SV_Position;
};

float4 vertex_main_inner() {
  countOneBits_65d2ae();
  return float4(0.0f, 0.0f, 0.0f, 0.0f);
}

tint_symbol vertex_main() {
  const float4 inner_result = vertex_main_inner();
  tint_symbol wrapper_result = (tint_symbol)0;
  wrapper_result.value = inner_result;
  return wrapper_result;
}

void fragment_main() {
  countOneBits_65d2ae();
  return;
}

[numthreads(1, 1, 1)]
void compute_main() {
  countOneBits_65d2ae();
  return;
}
