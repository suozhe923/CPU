.data
.text
	lui t0, 0xFFFF0
	li t1, 1
	lui t2, 0xDEADC
	addi t2, t2, 0xFFFFFEEF  # t2 = 0xDEADBEEF
	addi t3, t2, 0x10  # t3 = 0xDEADBEFF
input_num:
	sw t2, 0x20(t0)  # input mode indicator
	lw x3, 0x14(t0)  # load button1 to x3
	bne x3, t1, input_num  # if not pressed, loop
	
	sw t3, 0x20(t0)  # testing mode indicator
	lw x1, 0x0C(t0)  # load Switchlittle(testcase No.) to x1
	beq x1, x0, test2_0_start
	li a0, 1
	beq x1, a0, test2_1_start
	li a0, 2
	beq x1, a0, test2_2_input1
	li a0, 3
	beq x1, a0, test2_3_start
	li a0, 4
	beq x1, a0, test2_4_start
	li a0, 5
	beq x1, a0, test2_5_start
	li a0, 6
	beq x1, a0, test2_6
	li a0, 7
	beq x1, a0, test2_7_jal
	
finish:
	lw x3, 0x10(t0)  # load button0 to x3
	bne x3, t1, finish  # if not pressed, loop
	
	sw x0, 0x00(t0)  # clear LEDbig
	sw x0, 4(t0)  # clear LEDlittle
	j input_num
	
test2_0_start:
	li a0, 8  # loop times
	sw a0, 0x04(t0)  # display No. on LEDlittle
	lw x3, 0x18(t0)  # load button2 to x3
	bne x3, t1, test2_0_start  # if not pressed, loop
	
	lw x1, 0x08(t0)  # load Switchbig to x1
	li a1, 0  # i
	li a2, 0  # reversed
	
test2_0_loop:
	beq a1, a0, test2_0_done
	
	andi t4, x1, 1  # t4 = num & 1
	li t5, 7
	sub t5, t5, a1  # t5 = 7 - i
	sll t4, t4, t5  # t4 = (num & 1) << (7 - i)
	or a2, a2, t4  # reversed |= (num & 1) << (7 - i)
	
	srli x1, x1, 1  ## num >>= 1
	addi a1, a1, 1
	j test2_0_loop

test2_0_done:
	sw a2, 0x00(t0)  # store reversed to LEDbig
	j finish
	
test2_1_start:
	li a0, 9
	sw a0, 0x04(t0)  # display No. on LEDlittle
	lw x3, 0x18(t0)  # load button2 to x3
	bne x3, t1, test2_1_start  # if not pressed, loop
	
	lw x1, 0x08(t0)  # load Switchbig to x1
	mv x2, x1  # copy original for judgement
	li a1, 0  # i
	li a2, 0  # reversed
	
test2_1_loop:
	beq a1, a0, test2_1_done
	
	andi t4, x1, 1  # t4 = num & 1
	li t5, 7
	sub t5, t5, a1  # t5 = 7 - i
	sll t4, t4, t5  # t4 = (num & 1) << (7 - i)
	or a2, a2, t4  # reversed |= (num & 1) << (7 - i)
	
	srli x1, x1, 1  ## num >>= 1
	addi a1, a1, 1
	j test2_1_loop

test2_1_done:
	beq a2, x2, yes
	j no

test2_2_input1:
	li a0, 10
	sw a0, 0x04(t0)  # display No. on LEDlittle
	lw x3, 0x18(t0)  # load button2 to x3
	bne x3, t1, test2_2_input1  # if not pressed, loop
	
	lw x1, 0x08(t0)  # load Switchbig to x1
	slli x1, x1, 4  # 8 + 4 = 12bit
	sw x1, 0(x0)  # store a in 0x0
	
	# How to calculate:
	# num = (-1)^sign * (1 + frac/16) * 2^actualExp
	# (why frac/16? because we have 4 bits ACTUAL frac.)
	srli a0, x1, 11
	andi a0, a0, 1  # process sign bit
	sw a0, 4(x0)  # store sign bit
	srli a1, x1, 8
	andi a1, a1, 7  # process exp
	addi a1, a1, -3  # actual exp, bias = 2^(3-1) - 1 = 3.
	srli a2, x1, 4
	andi a2, a2, 0xF  # process frac
	
	addi a2, a2, 16  # (1 + frac/16) * 16
	sll a2, a2, a1  # (16 + frac) * 2^actualExp
	sw a2, 8(x0)  # store x16 num
	srli a2, a2, 4  # (1 + frac/16) * 2^actualExp
	li a1, 0  # ten
	beqz a0, test2_2_convert1
	sw t1, 0x00(t0)  # display sign bit on LEDbig
	
test2_2_convert1:
	# seg tubes only supports hex num
	# so we have to convert, like: 0h31 = 0x16 -> 0x31
	li a0, 10
	blt a2, a0, test2_2_display1  # if < 10, stop
	
	addi a2, a2, -10  # result -= 10
	addi a1, a1, 1  # ten bit++
	j test2_2_convert1
	
test2_2_display1:
	slli a1, a1, 4
	or a2, a2, a1  # ten | ones
	sw a2, 0x20(t0)  # display on seg tubes
	
test2_2_input2:
	lw x3, 0x1C(t0)  # load button3 to x3
	bne x3, t1, test2_2_input2  # if not pressed, loop
	
	sw x0, 0x00(t0)  # clear sign bit
	lw x1, 0x08(t0)  # load Switchbig to x1
	slli x1, x1, 4  # 8 + 4 = 12bit
	sw x1, 0x10(x0)  # store b in 0x10
	
	srli a0, x1, 11
	andi a0, a0, 1  # process sign bit
	sw a0, 0x14(x0)  # store sign bit
	srli a1, x1, 8
	andi a1, a1, 7  # process exp
	addi a1, a1, -3  # actual exp
	srli a2, x1, 4
	andi a2, a2, 0xF  # process frac
	
	addi a2, a2, 16  # (1 + frac/16) * 16
	sll a2, a2, a1  # (16 + frac) * 2^actualExp
	sw a2, 0x18(x0)  # store x16 num
	srli a2, a2, 4  # (1 + frac/16) * 2^actualExp
	li a1, 0  # ten
	beqz a0, test2_2_convert2
	sw t1, 0x00(t0)  # display sign bit on LEDbig
	
test2_2_convert2:
	li a0, 10
	blt a2, a0, test2_2_display2  # if < 10, stop
	
	addi a2, a2, -10  # result -= 10
	addi a1, a1, 1  # ten bit++
	j test2_2_convert2
	
test2_2_display2:
	slli a1, a1, 4
	or a2, a2, a1  # ten | ones
	sw a2, 0x20(t0)  # display on seg tubes
	j finish
	
test2_3_start:
	li a0, 11
	sw a0, 0x04(t0)  # display No. on LEDlittle
	lw s0, 4(x0)  # sign bit in test2_2_1
	lw a0, 8(x0)  # x16 num in test2_2_1
	lw s1, 0x14(x0)  # sign bit in test2_2_2
	lw a1, 0x18(x0)  # x16 num in test2_2_2
	beqz s0, test2_3_process  # if num1 > 0, skip neg
	neg a0, a0
	
test2_3_process:
	beqz s1, test2_3_calc
	neg a1, a1
	
test2_3_calc:
	add a2, a0, a1
	li a1, 0
	bgez a2, test2_3_pos
	sw t1, 0x00(t0)  # display sign bit on LEDbig
	neg a2, a2
	
test2_3_pos:
	srai a2, a2, 4
	
test2_3_convert:
	li a0, 10
	blt a2, a0, test2_3_display  # if < 10, stop
	
	addi a2, a2, -10  # result -= 10
	addi a1, a1, 1  # ten bit++
	j test2_3_convert
	
test2_3_display:
	slli a1, a1, 4
	or a2, a2, a1  # ten | ones
	sw a2, 0x20(t0)  # display on seg tubes
	j finish
	
test2_4_start:
	li a0, 12
	sw a0, 0x04(t0)  # display No. on LEDlittle
	lw x3, 0x18(t0)  # load button2 to x3
	bne x3, t1, test2_4_start  # if not pressed, loop
	
	lw x1, 0x08(t0)  # load Switchbig to x1
	slli x1, x1, 4  # data = int(data_bits, 2) << 4
	mv x2, x1  # copy original
	li a0, 3  # loop 4 times
	li a1, 0  # i
	li a2, 0x13  # poly = 10011
	
test2_4_loop:
	li a3, 7
	sub a3, a3, a1  # a3 = 7 - i
	sll a3, t1, a3  # a3 = 1 << (7 - i)
	and a3, x1, a3  # a3 = data & (1 << (7 - i))
	beqz a3, test2_4_skip
	sub a3, a0, a1  # a3 = 3 - i
	sll a3, a2, a3  # a3 = poly << (3 - i)
	xor x1, x1, a3  # data ^= (poly << (3 - i))
	
test2_4_skip:
	beq a0, a1, test2_4_done
	addi a1, a1, 1
	j test2_4_loop
	
test2_4_done:
	andi x1, x1, 0xF
	or x1, x1, x2  # original + crc
	sw x1, 0x00(t0)  # store result to LEDbig
	j finish
	
test2_5_start:
	li a0, 13
	sw a0, 0x04(t0)  # display No. on LEDlittle
	lw x3, 0x18(t0)  # load button2 to x3
	bne x3, t1, test2_5_start  # if not pressed, loop
	
	lw x1, 0x08(t0)  # load Switchbig to x1
	li a0, 3  # loop 4 times
	li a1, 0  # i
	li a2, 0x13  # poly = 10011
	
test2_5_loop:
	li a3, 7
	sub a3, a3, a1  # a3 = 7 - i
	sll a3, t1, a3  # a3 = 1 << (7 - i)
	and a3, x1, a3  # a3 = data & (1 << (7 - i))
	beqz a3, test2_5_skip
	sub a3, a0, a1  # a3 = 3 - i
	sll a3, a2, a3  # a3 = poly << (3 - i)
	xor x1, x1, a3  # data ^= (poly << (3 - i))
	
test2_5_skip:
	beq a0, a1, test2_5_done
	addi a1, a1, 1
	j test2_5_loop
	
test2_5_done:
	andi x1, x1, 0xF
	beqz x1, yes
	j no
	
test2_6:
	li a0, 14
	sw a0, 0x04(t0)  # display No. on LEDlittle
	sw t0, 0x20(t0)  # store t0 in seg tubes
	j finish
	
test2_7_jal:
	li a0, 15
	sw a0, 0x04(t0)  # display No. on LEDlittle
	lw x3, 0x18(t0)  # load button2 to x3
	bne x3, t1, test2_7_jal  # if not pressed, loop
	addi x0, x0, 0
	jal test2_7_jalr  # jump to test2_7_jalr
	sw t3, 0x00(t0)  # load 0xFF to LEDbig but skipped due to jalr
	addi x0, x0, 0  # NOP but skipped due to jalr
	
test2_7_jalr:
	sw x1, 0x20(t0)  # store x1 to seg tubes
	lw x3, 0x1C(t0)  # load button3 to x3
	bne x3, t1, test2_7_jalr  # if not pressed, loop
	la x2, test2_7_skip   # load the address of "sw t3, 0x00(t0)"
	jalr x1, x2, 4  # jump to "sw t3, 0x00(t0)" + 4 = "addi x0, x0, 0"
	
test2_7_skip:
	sw t3, 0x00(t0)  # load 0xFF to LEDbig but skipped due to jalr
	addi x0, x0, 0
	sw x1, 0x20(t0)  # store the result of jalr to seg tubes
	
test2_7_auipc:
	lw x3, 0x18(t0)  # load button2 to x3
	bne x3, t1, test2_7_auipc  # if not pressed, loop
	addi x0, x0, 0
	addi x0, x0, 0
	auipc a0, 0xABCDE  # a0 = 0xABCDE000 + pc
	sw a0, 0x20(t0)  # store the result of auipc to seg tubes
	j finish
	
yes:
	sw t1, 0x00(t0)
	j finish
	
no:
	sw x0, 0x00(t0)
	j finish
