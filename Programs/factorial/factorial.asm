xor s0, s0, 0
addi s1, s0, 8
addi s2, s0, 1
addi s3, s0, 1
addi s7, s0, 0
addi s8, s0, 1
addi s9, s0, 2

loop1:
blt s1, s9, end
addi s7, s3, 0
addi s2, s1, 0

lable:
blt s2, s9, endloop
add s3, s3, s7
sub s2, s2, s8
beq s9, s9, lablel

endloop:
sub s1, s1, s8
beq s9, s9, loop1
end:
sw s3, 0(s0)