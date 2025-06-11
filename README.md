# CPU
CS202 Course Project

For 20250528152411 version, you may follow the following steps to add `cpuclk` to your project:
1. Open `IP Catalog`, find and double click `Clocking Wizard` in `FPGA Features and Design` -> `Clocking`.
2. Rename the module to `cpuclk`.
3. In `Clocking Options` tab, choose `PLL`.
4. In `Output Clocks` tab, enable `clk_out1` and `clk_out2`, and rename them to `cpu_clk` and `uart_clk`, set the Output Freq to 23.000MHz and 10.000MHz, seperately.
5. In `Output Clocks` tab, disable `reset` and `locked` (if you can't find it, just scroll down the page and you will be able to see it).

For 20250513 version, you may follow the following steps to add `prgrom` and `RAM` to your project:

1. Open `IP Catalog`, find and double click `Block Memory Generator` in `Memories & Storage Elements` -> `RAMs & ROMs & BRAM`.
2. Rename the module to `prgrom` / `RAM`.
3. In `Basic` tab, change `Memory Type` to `Single Port ROM` for `prgrom` / `Single Port RAM` for `RAM`.
4. In `Port A Options` tab, set all `Width`s to 32, and set all `Depth`s to 16384. Change `Enable Port Type` to `Always Enabled`. Deselect `Primitives Output Register`.
5. In `Other Options` tab, enable `Load Init File` and select `RAM.coe` in `src\coes` folder for `RAM`/  `testcases.coe` or `testcase2.coe` in `src\coes` folder for `prgrom`.
