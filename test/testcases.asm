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
	lw x1, 0x0C(t0)  # Load Switchlittle(testcase No.) to x1
	beq x1, x0, test1_0_0
	li a0, 1
	beq x1, a0, test1_1
	li a0, 2
	beq x1, a0, test1_2
	li a0, 3
	beq x1, a0, test1_3
	li a0, 4
	beq x1, a0, test1_4
	li a0, 5
	beq x1, a0, test1_5
	li a0, 6
	beq x1, a0, test1_6
	li a0, 7
	beq x1, a0, test1_7
	
finish:
	lw x3, 0x10(t0)  # load button0 to x3
	bne x3, t1, finish  # if not pressed, loop
	
	sw x0, 0x00(t0)  # clear LEDbig
	sw x0, 4(t0)  # clear LEDlittle
	j input_num
	
test1_0_0:
	li a0, 0
	sw a0, 0x04(t0)  # display No. on LEDlittle
	lw x3, 0x18(t0)  # load button2 to x3
	bne x3, t1, test1_0_0  # if not pressed, loop
	
	lw x1, 0x08(t0)  # load Switchbig to x1
	sw x1, 0x00(t0)  # store x1 to LEDbig
	
test1_0_1:
	lw x3, 0x1C(t0)  # load button3 to x3
	bne x3, t1, test1_0_1  # if not pressed, loop
	
	lw x1, 0x08(t0)  # load Switchbig to x1
	sw x1, 0x00(t0)  # store x1 to LEDbig
	j finish
	
test1_1:
	li a0, 1
	sw a0, 0x04(t0)  # display No. on LEDlittle
	lw x3, 0x18(t0)  # load button2 to x3
	bne x3, t1, test1_1  # if not pressed, loop
	
	lb x1, 0x08(t0)  # load Switchbig to x1
	sw x1, 0x20(t0)  # display on seg tubes
	sw x1, 0(x0)  # store in 0x0
	j finish

test1_2:
	li a0, 2
	sw a0, 0x04(t0)  # display No. on LEDlittle
	lw x3, 0x18(t0)  # load button2 to x3
	bne x3, t1, test1_2  # if not pressed, loop
	
	lbu x1, 0x08(t0)  # load Switchbig to x1
	sw x1, 0x20(t0)  # display on seg tubes
	sw x1, 4(x0)  # store in 0x4
	j finish
	
test1_3:
	li a0, 3
	sw a0, 0x04(t0)  # display No. on LEDlittle
	lw s0, 0(x0)  # test1_1
	lw s1, 4(x0)  # test1_2
	beq s0, s1, yes
	j no
	
test1_4:
	li a0, 4
	sw a0, 0x04(t0)  # display No. on LEDlittle
	lw s0, 0(x0)  # test1_1
	lw s1, 4(x0)  # test1_2
	blt s0, s1, yes
	j no
	
test1_5:
	li a0, 5
	sw a0, 0x04(t0)  # display No. on LEDlittle
	lw s0, 0(x0)  # test1_1
	lw s1, 4(x0)  # test1_2
	bltu s0, s1, yes
	j no
	
test1_6:
	li a0, 6
	sw a0, 0x04(t0)  # display No. on LEDlittle
	lw s0, 0(x0)  # test1_1
	lw s1, 4(x0)  # test1_2
	slt s2, s0, s1
	sw s2, 0x00(t0)  # store result in LEDbig
	j finish
	
test1_7:
	li a0, 7
	sw a0, 0x04(t0)  # display No. on LEDlittle
	lw s0, 0(x0)  # test1_1
	lw s1, 4(x0)  # test1_2
	sltu s2, s0, s1
	sw s2, 0x00(t0)  # store result in LEDbig
	j finish
	
yes:
	sw t3, 0x00(t0)
	j finish
	
no:
	sw x0, 0x00(t0)
	j finish
