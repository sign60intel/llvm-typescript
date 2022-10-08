; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

declare void @use(i8)

define i1 @set_low_bit_mask_eq(i8 %x) {
; CHECK-LABEL: @set_low_bit_mask_eq(
; CHECK-NEXT:    [[TMP1:%.*]] = and i8 [[X:%.*]], -2
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[TMP1]], 18
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %sub = or i8 %x, 1
  %cmp = icmp eq i8 %sub, 19
  ret i1 %cmp
}

define <2 x i1> @set_low_bit_mask_ne(<2 x i8> %x) {
; CHECK-LABEL: @set_low_bit_mask_ne(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i8> [[X:%.*]], <i8 -4, i8 -4>
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne <2 x i8> [[TMP1]], <i8 16, i8 16>
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %sub = or <2 x i8> %x, <i8 3, i8 3>
  %cmp = icmp ne <2 x i8> %sub, <i8 19, i8 19>
  ret <2 x i1> %cmp
}

define i1 @set_low_bit_mask_ugt(i8 %x) {
; CHECK-LABEL: @set_low_bit_mask_ugt(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i8 [[X:%.*]], 19
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %sub = or i8 %x, 3
  %cmp = icmp ugt i8 %sub, 19
  ret i1 %cmp
}

define i1 @set_low_bit_mask_ult(i8 %x) {
; CHECK-LABEL: @set_low_bit_mask_ult(
; CHECK-NEXT:    [[SUB:%.*]] = or i8 [[X:%.*]], 3
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i8 [[SUB]], 19
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %sub = or i8 %x, 3
  %cmp = icmp ult i8 %sub, 19
  ret i1 %cmp
}

define i1 @set_low_bit_mask_uge(i8 %x) {
; CHECK-LABEL: @set_low_bit_mask_uge(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i8 [[X:%.*]], 19
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %sub = or i8 %x, 3
  %cmp = icmp uge i8 %sub, 20
  ret i1 %cmp
}

define i1 @set_low_bit_mask_ule(i8 %x) {
; CHECK-LABEL: @set_low_bit_mask_ule(
; CHECK-NEXT:    [[SUB:%.*]] = or i8 [[X:%.*]], 3
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i8 [[SUB]], 19
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %sub = or i8 %x, 3
  %cmp = icmp ule i8 %sub, 18
  ret i1 %cmp
}

define i1 @set_low_bit_mask_sgt(i8 %x) {
; CHECK-LABEL: @set_low_bit_mask_sgt(
; CHECK-NEXT:    [[SUB:%.*]] = or i8 [[X:%.*]], 3
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i8 [[SUB]], 20
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %sub = or i8 %x, 3
  %cmp = icmp sgt i8 %sub, 20
  ret i1 %cmp
}

define i1 @set_low_bit_mask_slt(i8 %x) {
; CHECK-LABEL: @set_low_bit_mask_slt(
; CHECK-NEXT:    [[SUB:%.*]] = or i8 [[X:%.*]], 15
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i8 [[SUB]], 19
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %sub = or i8 %x, 15
  %cmp = icmp slt i8 %sub, 19
  ret i1 %cmp
}

define i1 @set_low_bit_mask_sge(i8 %x) {
; CHECK-LABEL: @set_low_bit_mask_sge(
; CHECK-NEXT:    [[SUB:%.*]] = or i8 [[X:%.*]], 31
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i8 [[SUB]], 50
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %sub = or i8 %x, 31
  %cmp = icmp sge i8 %sub, 51
  ret i1 %cmp
}

define i1 @set_low_bit_mask_sle(i8 %x) {
; CHECK-LABEL: @set_low_bit_mask_sle(
; CHECK-NEXT:    [[SUB:%.*]] = or i8 [[X:%.*]], 63
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i8 [[SUB]], 69
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %sub = or i8 %x, 63
  %cmp = icmp sle i8 %sub, 68
  ret i1 %cmp
}

define i1 @eq_const_mask(i8 %x, i8 %y) {
; CHECK-LABEL: @eq_const_mask(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i8 [[TMP1]], -43
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[TMP2]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %b0 = or i8 %x, 42
  %b1 = or i8 %y, 42
  %cmp = icmp eq i8 %b0, %b1
  ret i1 %cmp
}

define <2 x i1> @ne_const_mask(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @ne_const_mask(
; CHECK-NEXT:    [[TMP1:%.*]] = xor <2 x i8> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i8> [[TMP1]], <i8 105, i8 -6>
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne <2 x i8> [[TMP2]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %b0 = or <2 x i8> %x, <i8 150, i8 5>
  %b1 = or <2 x i8> %y, <i8 150, i8 5>
  %cmp = icmp ne <2 x i8> %b0, %b1
  ret <2 x i1> %cmp
}

; negative test - predicate

define i1 @eq_const_mask_not_equality(i8 %x, i8 %y) {
; CHECK-LABEL: @eq_const_mask_not_equality(
; CHECK-NEXT:    [[B0:%.*]] = or i8 [[X:%.*]], 5
; CHECK-NEXT:    [[B1:%.*]] = or i8 [[Y:%.*]], 5
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i8 [[B0]], [[B1]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %b0 = or i8 %x, 5
  %b1 = or i8 %y, 5
  %cmp = icmp sgt i8 %b0, %b1
  ret i1 %cmp
}

; negative test - mismatched constants

define i1 @eq_const_mask_not_same(i8 %x, i8 %y) {
; CHECK-LABEL: @eq_const_mask_not_same(
; CHECK-NEXT:    [[B0:%.*]] = or i8 [[X:%.*]], 5
; CHECK-NEXT:    [[B1:%.*]] = or i8 [[Y:%.*]], 6
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[B0]], [[B1]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %b0 = or i8 %x, 5
  %b1 = or i8 %y, 6
  %cmp = icmp eq i8 %b0, %b1
  ret i1 %cmp
}

; negative test - mismatched logic

define i1 @eq_const_mask_wrong_opcode(i8 %x, i8 %y) {
; CHECK-LABEL: @eq_const_mask_wrong_opcode(
; CHECK-NEXT:    [[B0:%.*]] = or i8 [[X:%.*]], 5
; CHECK-NEXT:    [[B1:%.*]] = xor i8 [[Y:%.*]], 5
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[B0]], [[B1]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %b0 = or i8 %x, 5
  %b1 = xor i8 %y, 5
  %cmp = icmp eq i8 %b0, %b1
  ret i1 %cmp
}

; negative test - no extra uses

define i1 @eq_const_mask_use1(i8 %x, i8 %y) {
; CHECK-LABEL: @eq_const_mask_use1(
; CHECK-NEXT:    [[B0:%.*]] = or i8 [[X:%.*]], 5
; CHECK-NEXT:    call void @use(i8 [[B0]])
; CHECK-NEXT:    [[B1:%.*]] = or i8 [[Y:%.*]], 5
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[B0]], [[B1]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %b0 = or i8 %x, 5
  call void @use(i8 %b0)
  %b1 = or i8 %y, 5
  %cmp = icmp eq i8 %b0, %b1
  ret i1 %cmp
}

; negative test - no extra uses

define i1 @eq_const_mask_use2(i8 %x, i8 %y) {
; CHECK-LABEL: @eq_const_mask_use2(
; CHECK-NEXT:    [[B0:%.*]] = or i8 [[X:%.*]], 5
; CHECK-NEXT:    [[B1:%.*]] = or i8 [[Y:%.*]], 5
; CHECK-NEXT:    call void @use(i8 [[B1]])
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[B0]], [[B1]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %b0 = or i8 %x, 5
  %b1 = or i8 %y, 5
  call void @use(i8 %b1)
  %cmp = icmp eq i8 %b0, %b1
  ret i1 %cmp
}

; (x | (x - 1)) s< 0

define <2 x i1> @decrement_slt_0(<2 x i8> %x) {
; CHECK-LABEL: @decrement_slt_0(
; CHECK-NEXT:    [[R:%.*]] = icmp slt <2 x i8> [[X:%.*]], <i8 1, i8 1>
; CHECK-NEXT:    ret <2 x i1> [[R]]
;
  %dec = add <2 x i8> %x, <i8 -1, i8 -1>
  %or = or <2 x i8> %dec, %x
  %r = icmp slt <2 x i8> %or, zeroinitializer
  ret <2 x i1> %r
}

define i1 @decrement_slt_0_commute_use1(i8 %px) {
; CHECK-LABEL: @decrement_slt_0_commute_use1(
; CHECK-NEXT:    [[X:%.*]] = mul i8 [[PX:%.*]], 42
; CHECK-NEXT:    [[DEC:%.*]] = add i8 [[X]], -1
; CHECK-NEXT:    call void @use(i8 [[DEC]])
; CHECK-NEXT:    [[R:%.*]] = icmp slt i8 [[X]], 1
; CHECK-NEXT:    ret i1 [[R]]
;
  %x = mul i8 %px, 42 ; thwart complexity-based canonicalization
  %dec = add i8 %x, -1
  call void @use(i8 %dec)
  %or = or i8 %x, %dec
  %r = icmp slt i8 %or, 0
  ret i1 %r
}

define i1 @decrement_slt_0_use2(i8 %x) {
; CHECK-LABEL: @decrement_slt_0_use2(
; CHECK-NEXT:    [[DEC:%.*]] = add i8 [[X:%.*]], -1
; CHECK-NEXT:    [[OR:%.*]] = or i8 [[DEC]], [[X]]
; CHECK-NEXT:    call void @use(i8 [[OR]])
; CHECK-NEXT:    [[R:%.*]] = icmp slt i8 [[X]], 1
; CHECK-NEXT:    ret i1 [[R]]
;
  %dec = add i8 %x, -1
  %or = or i8 %dec, %x
  call void @use(i8 %or)
  %r = icmp slt i8 %or, 0
  ret i1 %r
}

; negative test - wrong cmp constant

define i1 @decrement_slt_n1(i8 %x) {
; CHECK-LABEL: @decrement_slt_n1(
; CHECK-NEXT:    [[DEC:%.*]] = add i8 [[X:%.*]], -1
; CHECK-NEXT:    [[OR:%.*]] = or i8 [[DEC]], [[X]]
; CHECK-NEXT:    [[R:%.*]] = icmp slt i8 [[OR]], -1
; CHECK-NEXT:    ret i1 [[R]]
;
  %dec = add i8 %x, -1
  %or = or i8 %dec, %x
  %r = icmp slt i8 %or, -1
  ret i1 %r
}

; negative test - wrong add constant

define i1 @not_decrement_slt_0(i8 %x) {
; CHECK-LABEL: @not_decrement_slt_0(
; CHECK-NEXT:    [[DEC:%.*]] = add i8 [[X:%.*]], -2
; CHECK-NEXT:    [[OR:%.*]] = or i8 [[DEC]], [[X]]
; CHECK-NEXT:    [[R:%.*]] = icmp slt i8 [[OR]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %dec = add i8 %x, -2
  %or = or i8 %dec, %x
  %r = icmp slt i8 %or, 0
  ret i1 %r
}

; (x | (x - 1)) s> -1

define <2 x i1> @decrement_sgt_n1(<2 x i8> %x) {
; CHECK-LABEL: @decrement_sgt_n1(
; CHECK-NEXT:    [[R:%.*]] = icmp sgt <2 x i8> [[X:%.*]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[R]]
;
  %dec = add <2 x i8> %x, <i8 -1, i8 -1>
  %or = or <2 x i8> %dec, %x
  %r = icmp sgt <2 x i8> %or, <i8 -1, i8 -1>
  ret <2 x i1> %r
}

define i1 @decrement_sgt_n1_commute_use1(i8 %px) {
; CHECK-LABEL: @decrement_sgt_n1_commute_use1(
; CHECK-NEXT:    [[X:%.*]] = mul i8 [[PX:%.*]], 42
; CHECK-NEXT:    [[DEC:%.*]] = add i8 [[X]], -1
; CHECK-NEXT:    call void @use(i8 [[DEC]])
; CHECK-NEXT:    [[R:%.*]] = icmp sgt i8 [[X]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %x = mul i8 %px, 42 ; thwart complexity-based canonicalization
  %dec = add i8 %x, -1
  call void @use(i8 %dec)
  %or = or i8 %x, %dec
  %r = icmp sgt i8 %or, -1
  ret i1 %r
}

define i1 @decrement_sgt_n1_use2(i8 %x) {
; CHECK-LABEL: @decrement_sgt_n1_use2(
; CHECK-NEXT:    [[DEC:%.*]] = add i8 [[X:%.*]], -1
; CHECK-NEXT:    [[OR:%.*]] = or i8 [[DEC]], [[X]]
; CHECK-NEXT:    call void @use(i8 [[OR]])
; CHECK-NEXT:    [[R:%.*]] = icmp sgt i8 [[X]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %dec = add i8 %x, -1
  %or = or i8 %dec, %x
  call void @use(i8 %or)
  %r = icmp sgt i8 %or, -1
  ret i1 %r
}

; negative test - wrong cmp constant

define i1 @decrement_sgt_0(i8 %x) {
; CHECK-LABEL: @decrement_sgt_0(
; CHECK-NEXT:    [[DEC:%.*]] = add i8 [[X:%.*]], -1
; CHECK-NEXT:    [[OR:%.*]] = or i8 [[DEC]], [[X]]
; CHECK-NEXT:    [[R:%.*]] = icmp sgt i8 [[OR]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %dec = add i8 %x, -1
  %or = or i8 %dec, %x
  %r = icmp sgt i8 %or, 0
  ret i1 %r
}

; negative test - wrong add constant

define i1 @not_decrement_sgt_n1(i8 %x) {
; CHECK-LABEL: @not_decrement_sgt_n1(
; CHECK-NEXT:    [[DEC:%.*]] = add i8 [[X:%.*]], -2
; CHECK-NEXT:    [[OR:%.*]] = or i8 [[DEC]], [[X]]
; CHECK-NEXT:    [[R:%.*]] = icmp sgt i8 [[OR]], -1
; CHECK-NEXT:    ret i1 [[R]]
;
  %dec = add i8 %x, -2
  %or = or i8 %dec, %x
  %r = icmp sgt i8 %or, -1
  ret i1 %r
}