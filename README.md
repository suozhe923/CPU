# CPU
CS202

For 20250528152411 version, you may follow the following steps to add `cpuclk` to your project:
1. Open `IP Catalog`, find and double click `Clocking Wizard` in `FPGA Features and Design` -> `Clocking`.
2. Rename the module to `cpuclk`.
3. In `Clocking Options` tab, choose `PLL`.
4. In `Output Clocks` tab, enable `clk_out1` and `clk_out2`, and rename them to `cpu_clk` and `uart_clk`, set the Output Freq to 23.000MHz and 10.000MHz, seperately.
5. In `Output Clocks` tab, disable `reset` and `locked` (if you can't find it, just scroll down the page and you will be able to see it).
