
ByteAddressBuffer tint_symbol : register(t0);
RWByteAddressBuffer tint_symbol_1 : register(u1);
void v(uint offset, matrix<float16_t, 2, 4> obj) {
  tint_symbol_1.Store<vector<float16_t, 4> >((offset + 0u), obj[0u]);
  tint_symbol_1.Store<vector<float16_t, 4> >((offset + 8u), obj[1u]);
}

matrix<float16_t, 2, 4> v_1(uint offset) {
  return matrix<float16_t, 2, 4>(tint_symbol.Load<vector<float16_t, 4> >((offset + 0u)), tint_symbol.Load<vector<float16_t, 4> >((offset + 8u)));
}

[numthreads(1, 1, 1)]
void main() {
  v(0u, v_1(0u));
}

