; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=sse2 | FileCheck %s --check-prefixes=SSE,SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=sse4.1 | FileCheck %s --check-prefixes=SSE,SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=avx2 | FileCheck %s --check-prefixes=AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=avx512f | FileCheck %s --check-prefixes=AVX,AVX512

; Verify that we don't scalarize a packed vector shift left of 16-bit
; signed integers if the amount is a constant build_vector.
; Check that we produce a SSE2 packed integer multiply (pmullw) instead.

define <8 x i16> @test1(<8 x i16> %a) {
; SSE-LABEL: test1:
; SSE:       # %bb.0:
; SSE-NEXT:    pmullw {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test1:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmullw {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %shl = shl <8 x i16> %a, <i16 1, i16 1, i16 2, i16 3, i16 7, i16 0, i16 9, i16 11>
  ret <8 x i16> %shl
}

define <8 x i16> @test2(<8 x i16> %a) {
; SSE-LABEL: test2:
; SSE:       # %bb.0:
; SSE-NEXT:    pmullw {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test2:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmullw {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %shl = shl <8 x i16> %a, <i16 0, i16 undef, i16 0, i16 0, i16 1, i16 undef, i16 -1, i16 1>
  ret <8 x i16> %shl
}

; Verify that a vector shift left of 32-bit signed integers is simply expanded
; into a SSE4.1 pmulld (instead of cvttps2dq + pmulld) if the vector of shift
; counts is a constant build_vector.

define <4 x i32> @test3(<4 x i32> %a) {
; SSE2-LABEL: test3:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE2-NEXT:    pmuludq %xmm0, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; SSE2-NEXT:    pmuludq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test3:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pmulld {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test3:
; AVX:       # %bb.0:
; AVX-NEXT:    vpsllvd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %shl = shl <4 x i32> %a, <i32 1, i32 -1, i32 2, i32 -3>
  ret <4 x i32> %shl
}

define <4 x i32> @test4(<4 x i32> %a) {
; SSE2-LABEL: test4:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa %xmm0, %xmm1
; SSE2-NEXT:    pslld $1, %xmm1
; SSE2-NEXT:    shufps  {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test4:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movdqa %xmm0, %xmm1
; SSE41-NEXT:    pslld $1, %xmm1
; SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm1[4,5,6,7]
; SSE41-NEXT:    retq
;
; AVX-LABEL: test4:
; AVX:       # %bb.0:
; AVX-NEXT:    vpsllvd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %shl = shl <4 x i32> %a, <i32 0, i32 0, i32 1, i32 1>
  ret <4 x i32> %shl
}

; If we have AVX/SSE2 but not AVX2, verify that the following shift is split
; into two pmullw instructions. With AVX2, the test case below would produce
; a single vpmullw.

define <16 x i16> @test5(<16 x i16> %a) {
; SSE-LABEL: test5:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa {{.*#+}} xmm2 = [2,2,4,8,128,1,512,2048]
; SSE-NEXT:    pmullw %xmm2, %xmm0
; SSE-NEXT:    pmullw %xmm2, %xmm1
; SSE-NEXT:    retq
;
; AVX-LABEL: test5:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmullw {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; AVX-NEXT:    retq
  %shl = shl <16 x i16> %a, <i16 1, i16 1, i16 2, i16 3, i16 7, i16 0, i16 9, i16 11, i16 1, i16 1, i16 2, i16 3, i16 7, i16 0, i16 9, i16 11>
  ret <16 x i16> %shl
}

; If we have AVX/SSE4.1 but not AVX2, verify that the following shift is split
; into two pmulld instructions. With AVX2, the test case below would produce
; a single vpsllvd instead.

define <8 x i32> @test6(<8 x i32> %a) {
; SSE2-LABEL: test6:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [2,2,4,8]
; SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; SSE2-NEXT:    pmuludq %xmm2, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SSE2-NEXT:    movdqa {{.*#+}} xmm4 = [2,2,8,8]
; SSE2-NEXT:    pmuludq %xmm4, %xmm3
; SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm3[0,2,2,3]
; SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm3[0],xmm0[1],xmm3[1]
; SSE2-NEXT:    pmuludq %xmm1, %xmm2
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[0,2,2,3]
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; SSE2-NEXT:    pmuludq %xmm4, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; SSE2-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; SSE2-NEXT:    movdqa %xmm2, %xmm1
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test6:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movdqa {{.*#+}} xmm2 = [2,2,4,8]
; SSE41-NEXT:    pmulld %xmm2, %xmm0
; SSE41-NEXT:    pmulld %xmm2, %xmm1
; SSE41-NEXT:    retq
;
; AVX-LABEL: test6:
; AVX:       # %bb.0:
; AVX-NEXT:    vpsllvd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; AVX-NEXT:    retq
  %shl = shl <8 x i32> %a, <i32 1, i32 1, i32 2, i32 3, i32 1, i32 1, i32 2, i32 3>
  ret <8 x i32> %shl
}

; With AVX2 and AVX512, the test case below should produce a sequence of
; two vpmullw instructions. On SSE2 instead, we split the shift in four
; parts and then we convert each part into a pmullw.

define <32 x i16> @test7(<32 x i16> %a) {
; SSE-LABEL: test7:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa {{.*#+}} xmm4 = [2,2,4,8,128,1,512,2048]
; SSE-NEXT:    pmullw %xmm4, %xmm0
; SSE-NEXT:    pmullw %xmm4, %xmm1
; SSE-NEXT:    pmullw %xmm4, %xmm2
; SSE-NEXT:    pmullw %xmm4, %xmm3
; SSE-NEXT:    retq
;
; AVX2-LABEL: test7:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vbroadcasti128 {{.*#+}} ymm2 = [2,2,4,8,128,1,512,2048,2,2,4,8,128,1,512,2048]
; AVX2-NEXT:    # ymm2 = mem[0,1,0,1]
; AVX2-NEXT:    vpmullw %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpmullw %ymm2, %ymm1, %ymm1
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test7:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vextracti64x4 $1, %zmm0, %ymm1
; AVX512-NEXT:    vbroadcasti128 {{.*#+}} ymm2 = [2,2,4,8,128,1,512,2048,2,2,4,8,128,1,512,2048]
; AVX512-NEXT:    # ymm2 = mem[0,1,0,1]
; AVX512-NEXT:    vpmullw %ymm2, %ymm1, %ymm1
; AVX512-NEXT:    vpmullw %ymm2, %ymm0, %ymm0
; AVX512-NEXT:    vinserti64x4 $1, %ymm1, %zmm0, %zmm0
; AVX512-NEXT:    retq
  %shl = shl <32 x i16> %a, <i16 1, i16 1, i16 2, i16 3, i16 7, i16 0, i16 9, i16 11, i16 1, i16 1, i16 2, i16 3, i16 7, i16 0, i16 9, i16 11, i16 1, i16 1, i16 2, i16 3, i16 7, i16 0, i16 9, i16 11, i16 1, i16 1, i16 2, i16 3, i16 7, i16 0, i16 9, i16 11>
  ret <32 x i16> %shl
}

; Similar to test7; the difference is that with AVX512 support
; we only produce a single vpsllvd/vpsllvq instead of a pair of vpsllvd/vpsllvq.

define <16 x i32> @test8(<16 x i32> %a) {
; SSE2-LABEL: test8:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm4 = [2,2,4,8]
; SSE2-NEXT:    pshufd {{.*#+}} xmm5 = xmm0[1,1,3,3]
; SSE2-NEXT:    pmuludq %xmm4, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SSE2-NEXT:    movdqa {{.*#+}} xmm6 = [2,2,8,8]
; SSE2-NEXT:    pmuludq %xmm6, %xmm5
; SSE2-NEXT:    pshufd {{.*#+}} xmm5 = xmm5[0,2,2,3]
; SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm5[0],xmm0[1],xmm5[1]
; SSE2-NEXT:    pshufd {{.*#+}} xmm5 = xmm1[1,1,3,3]
; SSE2-NEXT:    pmuludq %xmm4, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; SSE2-NEXT:    pmuludq %xmm6, %xmm5
; SSE2-NEXT:    pshufd {{.*#+}} xmm5 = xmm5[0,2,2,3]
; SSE2-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm5[0],xmm1[1],xmm5[1]
; SSE2-NEXT:    pshufd {{.*#+}} xmm5 = xmm2[1,1,3,3]
; SSE2-NEXT:    pmuludq %xmm4, %xmm2
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[0,2,2,3]
; SSE2-NEXT:    pmuludq %xmm6, %xmm5
; SSE2-NEXT:    pshufd {{.*#+}} xmm5 = xmm5[0,2,2,3]
; SSE2-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm5[0],xmm2[1],xmm5[1]
; SSE2-NEXT:    pmuludq %xmm3, %xmm4
; SSE2-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[0,2,2,3]
; SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm3[1,1,3,3]
; SSE2-NEXT:    pmuludq %xmm6, %xmm3
; SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm3[0,2,2,3]
; SSE2-NEXT:    punpckldq {{.*#+}} xmm4 = xmm4[0],xmm3[0],xmm4[1],xmm3[1]
; SSE2-NEXT:    movdqa %xmm4, %xmm3
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test8:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movdqa {{.*#+}} xmm4 = [2,2,4,8]
; SSE41-NEXT:    pmulld %xmm4, %xmm0
; SSE41-NEXT:    pmulld %xmm4, %xmm1
; SSE41-NEXT:    pmulld %xmm4, %xmm2
; SSE41-NEXT:    pmulld %xmm4, %xmm3
; SSE41-NEXT:    retq
;
; AVX2-LABEL: test8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vbroadcasti128 {{.*#+}} ymm2 = [1,1,2,3,1,1,2,3]
; AVX2-NEXT:    # ymm2 = mem[0,1,0,1]
; AVX2-NEXT:    vpsllvd %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpsllvd %ymm2, %ymm1, %ymm1
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test8:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpsllvd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %zmm0, %zmm0
; AVX512-NEXT:    retq
  %shl = shl <16 x i32> %a, <i32 1, i32 1, i32 2, i32 3, i32 1, i32 1, i32 2, i32 3, i32 1, i32 1, i32 2, i32 3, i32 1, i32 1, i32 2, i32 3>
  ret <16 x i32> %shl
}

; The shift from 'test9' gets shifted separately and blended if we don't have AVX2/AVX512f support.

define <8 x i64> @test9(<8 x i64> %a) {
; SSE2-LABEL: test9:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa %xmm1, %xmm4
; SSE2-NEXT:    psllq $2, %xmm4
; SSE2-NEXT:    psllq $3, %xmm1
; SSE2-NEXT:    movsd {{.*#+}} xmm1 = xmm4[0],xmm1[1]
; SSE2-NEXT:    movdqa %xmm3, %xmm4
; SSE2-NEXT:    psllq $2, %xmm4
; SSE2-NEXT:    psllq $3, %xmm3
; SSE2-NEXT:    movsd {{.*#+}} xmm3 = xmm4[0],xmm3[1]
; SSE2-NEXT:    paddq %xmm0, %xmm0
; SSE2-NEXT:    paddq %xmm2, %xmm2
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test9:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movdqa %xmm1, %xmm4
; SSE41-NEXT:    psllq $3, %xmm4
; SSE41-NEXT:    psllq $2, %xmm1
; SSE41-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1,2,3],xmm4[4,5,6,7]
; SSE41-NEXT:    movdqa %xmm3, %xmm4
; SSE41-NEXT:    psllq $3, %xmm4
; SSE41-NEXT:    psllq $2, %xmm3
; SSE41-NEXT:    pblendw {{.*#+}} xmm3 = xmm3[0,1,2,3],xmm4[4,5,6,7]
; SSE41-NEXT:    paddq %xmm0, %xmm0
; SSE41-NEXT:    paddq %xmm2, %xmm2
; SSE41-NEXT:    retq
;
; AVX2-LABEL: test9:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm2 = [1,1,2,3]
; AVX2-NEXT:    vpsllvq %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpsllvq %ymm2, %ymm1, %ymm1
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test9:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpsllvq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %zmm0, %zmm0
; AVX512-NEXT:    retq
  %shl = shl <8 x i64> %a, <i64 1, i64 1, i64 2, i64 3, i64 1, i64 1, i64 2, i64 3>
  ret <8 x i64> %shl
}