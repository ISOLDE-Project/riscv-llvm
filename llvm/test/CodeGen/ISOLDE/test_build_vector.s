.text
	.attribute	4, 16
	.attribute	5, "rv32i2p0_f2p0_d2p0_v1p0_zve32f1p0_zve32x1p0_zve64d1p0_zve64f1p0_zve64x1p0_zvl128b1p0_zvl32b1p0_zvl64b1p0"
	.file	"test_build_vector.ll"
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0                          # -- Begin function test
.LCPI0_0:
	.word	1                               # 0x1
	.word	28                              # 0x1c
	.word	28                              # 0x1c
	.word	3                               # 0x3
	.text
	.globl	test
	.p2align	2
	.type	test,@function
	.variant_cc	test
test:                                   # @test
	.cfi_startproc
# %bb.0:
	lui	a0, %hi(.LCPI0_0)
	addi	a0, a0, %lo(.LCPI0_0)
	vsetivli	zero, 4, e32, m1, ta, ma
	vle32.v	v8, (a0)
	ret
.Lfunc_end0:
	.size	test, .Lfunc_end0-test
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits