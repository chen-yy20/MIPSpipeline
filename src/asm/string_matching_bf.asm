.data
str: .space 512
pattern: .space 512
filename: .asciiz "test.dat"

.text
main:
#fopen 直接手动输入 不需要翻译成机器码
la $a0, filename #load filename
li $a1, 0 #flag
li $a2, 0 #mode
li $v0, 13 #open file syscall index
syscall

#read str
move $a0, $v0 #load file description to $a0
# addu 0x00022021
la $a1, str
# a1 字符串手动存入
li $a2, 1
# addiu 0x24060001
li $s0, 0 #len_pattern = 0
# addiu 0x24100000
read_str_entry:
# if s0 != 512 loop exit
slti $t0, $s0, 512
# 0x2a080200
beqz $t0, read_str_exit
# 0x11000008
li $v0, 14 #read file syscall index
syscall
lb $t0, 0($a1)
# lb 0x80a80000
addi $t1, $zero, '\n' # with ASCII
# 2009000a
# if t0 != \n exit loop
beq $t0, $t1, read_str_exit
# 11090003
addi $a1, $a1, 1
# 20a50001
addi $s0, $s0, 1
# 22100001
j read_str_entry
# 0810000B

read_str_exit:
#read pattern
la $a1, pattern
li $a2, 1
li $s1, 0 #len_pattern = 0

read_pattern_entry:
slti $t0, $s1, 512
beqz $t0, read_pattern_exit
li $v0, 14 #read file syscall index
syscall
lb $t0, 0($a1) # 1 char 1 byte
addi $t1, $zero, '\n'
beq $t0, $t1, read_pattern_exit
addi $a1, $a1, 1
addi $s1, $s1, 1
j read_pattern_entry

read_pattern_exit:
#close file
li $v0, 16 #close file syscall index
syscall

#call brute_force
move $a0, $s0
# 00102021 s0为字符串长度 initial
la $a1, str
# a1 为字符串首字 initial
move $a2, $s1 
# 00113021 s1为模式串长度 initial
la $a3, pattern
# a3 为模式串首地址
jal brute_force
# jump 再说
#printf
move $a0, $v0
li $v0, 1
syscall
#return 0
li $a0, 0
li $v0, 17
syscall


brute_force:
##### your code here #####
## str and pattern refer to the location of the list
# s0 = len(str) s1=len(pattern)
# t4, t5 store the current char
li $t0, 0 # t0 => cnt
# 24080000
li $t1, 0 # t1 => i
# 24090000
sub $t6, $s0, $s1 # len_str - len_pattern
# 02117022
outer_loop:
slt $t3, $t6, $t1
# 01C9582A
bnez $t3, outer_loop_break
# TODO 1560000F
li $t2, 0 # t2 => j
# 240a0000
inner_loop:
slt $t3, $t2, $s1
# 0151582A
beqz $t3, inner_loop_break
# 11600008
add $t3, $t1, $t2
# 012A5820
add $s2, $a1, $t3
# 00AB9020
add $s3, $a3, $t2
# 00EA9820
lb $t4, 0($s2) #str[i+j]
# 824C0000
lb $t5, 0($s3) #pattern[j]
# 826D0000
bne $t4, $t5, inner_loop_break
# bne 158D0002
addi $t2, $t2, 1
# 214A0001
j inner_loop
# jump

inner_loop_break:
bne $t2, $s1, not_if
# bne 15510001
addi $t0, $t0, 1
# 21080001
not_if:
addi $t1, $t1, 1
# 21290001
j outer_loop
# jump
outer_loop_break:
move $v0, $t0 # return cnt
# 00400118
jr $ra
# 03e00008










