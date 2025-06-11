.data
.text
	lui t0, 0xFFFF0
loop:
	lw x1, 8(t0)  # Load Switchbig to t0
	lw x2, 12(t0)  # Load Switchlittle to t1
	sw x1, 0(t0)  # Store t0 to LEDbig
	sw x2, 4(t0)  # Store t1 to LEDlittle
	sw x2, 20(t0)  # Copy to seg tubes
	j loop