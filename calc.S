# 
#     (32 + 1) * (12 * 1024 + n)
# p = ----------------------------
#       2048 * 32 * DIV * baud
#


#if QTSPIM
	.text
	.globl  main
main:
#endif
li $a0, 115200
# n
la $t0, PLL_FREQ
lw $t0, 0 ($t0)
li $v0, 0x0003ff00
and $v0, $v0, $t0
sra $v0, $v0, 8
li $v1, 0x0000003f
and $v1, $v1, $t0
sll $v1, $v1, 10
or $v1, $v1, $v0

# dividend
li $t0, 12288
addu $v1, $v1, $t0
sll $t0, $v1, 5
addu $v1, $v1, $t0

# divisor
la $t0, PLL_FREQ
lw $t0, 4 ($t0)
sra $t0, $t0, 14
andi $v0, $t0, 0xf
sll $v0, $v0, 16 # 2048 * 32 * DIV
multu $v0, $a0
nop
mflo $v0

# do division
divu $v1, $v0
nop
mfhi $v1
mflo $v0

#if QTSPIM
	.data
PLL_FREQ:      .word 0x1c
PLL_DIV_PARAM: .word 0x92392a00
CONFIG_A0:     .word 115200
#endif
