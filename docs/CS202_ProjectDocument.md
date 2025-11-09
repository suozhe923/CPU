# Computer Organization Project Document

## Labor Division

12312125 Zhu Mingyu(@[suozhe923](https://github.com/suozhe923)): CPU Top Module, `DMem`, `WriteMux`, Module Bug fixes (Contribution Percentage: $30\%$)

12312109 Li Honglin(@[Haldoctor](https://github.com/Haldoctor)): `IFetch`, `Decoder` (Contribution Percentage: $30\%$)

12312706 Zhou Liangyu(@[ChaosZ-1702](https://github.com/ChaosZ-1702)): `Controller`, Memory & IO Processing, Testcases & Document Writing (Contribution Percentage: $40\%$)

## Development Plan Schedule

| Date      | Work                                                         |
| :-------- | ------------------------------------------------------------ |
| 2025-5-11 | Complete basic modules(`IFetch`, `Decoder`, `Controller`, `ALU`, `ALUControl`) |
| 2025-5-12 | Complete CPU top module(`CPU`) and 7-seg digital tubes display module(`display_assign`) |
| 2025-5-13 | Fix basic module bugs, conduct unit test, midterm defense finished |
| 2025-5-25 | Optimize module structure                                    |
| 2025-5-27 | Complete memory and IO processing module(`MemOrIO`)          |
| 2025-5-28 | Complete on-board test of instruction execution, fix bugs, adjust CPU clock |
| 2025-5-29 | Complete the assembly of basic test scenario 1               |
| 2025-5-30 | Complete on-board test of basic test scenario 1              |
| 2025-5-31 | Complete the assembly of basic test scenario 2               |
| 2025-6-1  | Complete on-board test of basic test scenario 2 and final test |
| 2025-6-2  | Final defense finished:)                                     |
| 2025-6-6  | Complete report writing                                      |

All the above works were completed on time.

Version modification records: Please refer to the commit log of [suozhe923/CPU](https://github.com/suozhe923/CPU).

## CPU Architecture Design

### Basic Features

A **single-cycle** CPU based on the **Harvard** architecture, with **32** 32-bit registers.

**CPU Clock Frequency**: 23 MHz. 

**CPI**: 1

**Addressing unit**: **Word-addressable** memory, each address corresponds to 4 bytes(32 bits).

**Instruction space**: **2 ^ 14 * 4 bytes = 65536 Bytes = 64 KB**, starting from address **0x00000000**.

**Data space**: **2 ^ 14 * 4 bytes = 65536 Bytes = 64 KB**, starting from address **0x00000000**.

**Stack space**: Starting from address **0x0000FFFC**.

### ISA

The following instructions are based on the RISC-V basic instruction set.

| Instruction          | Type | Description                                       |
| -------------------- | ---- | ------------------------------------------------- |
| `add rd, rs1, rs2`   | R    | `rd = rs1 + rs2`                                  |
| `sub rd, rs1, rs2`   | R    | `rd = rs1 - rs2`                                  |
| `xor rd, rs1, rs2`   | R    | `rd = rs1 ^ rs2`                                  |
| `or rd, rs1, rs2`    | R    | `rd = rs1 | rs2`                                  |
| `and rd, rs1, rs2`   | R    | `rd = rs1 & rs2`                                  |
| `sll rd, rs1, rs2`   | R    | `rd = rs1 << rs2`                                 |
| `srl rd, rs1, rs2`   | R    | `rd = rs1 >> rs2`                                 |
| `sra rd, rs1, rs2`   | R    | `rd = rs1 >>> rs2`                                |
| `slt rd, rs1, rs2`   | R    | `rd = (rs1 < rs2) ? 1 : 0` (signed)               |
| `sltu rd, rs1, rs2`  | R    | `rd = (rs1 < rs2) ? 1 : 0` (unsigned)             |
| `addi rd, rs1, imm`  | I    | `rd = rs1 + imm`                                  |
| `xori rd, rs1, imm`  | I    | `rd = rs1 ^ imm`                                  |
| `ori rd, rs1, imm`   | I    | `rd = rs1 | imm`                                  |
| `andi rd, rs1, imm`  | I    | `rd = rs1 & imm`                                  |
| `slli rd, rs1, imm`  | I    | `rd = rs1 << imm[4:0]`                            |
| `srli rd, rs1, imm`  | I    | `rd = rs1 >> imm[4:0]`                            |
| `srai rd, rs1, imm`  | I    | `rd = rs1 >>> imm[4:0]`                           |
| `slti rd, rs1, imm`  | I    | `rd = (rs1 < imm) ? 1 : 0` (signed)               |
| `sltiu rd, rs1, imm` | I    | `rd = (rs1 < imm) ? 1 : 0` (unsigned)             |
| `lb rd, imm(rs1)`    | I    | `rd = {24’bM[rs1+imm][7],M[rs1+imm][7:0]}`        |
| `lh rd, imm(rs1)`    | I    | `rd = {16’bM[rs1+imm][15],M[rs1+imm][15:0]}`      |
| `lw rd, imm(rs1)`    | I    | `rd = M[rs1 + imm][31:0]`                         |
| `lbu rd, imm(rs1)`   | I    | `rd = {24’b0,M[rs1+imm][7:0]}`                    |
| `lhu rd, imm(rs1)`   | I    | `rd = {16’b0,M[rs1+imm][15:0]}`                   |
| `sw rs2, imm(rs1)`   | S    | `M[rs1+imm][31:0] =rs2[31:0]`                     |
| `beq rs1, rs2, imm`  | B    | `if (rs1 == rs2) PC = PC + {imm,1’b0}`            |
| `bne rs1, rs2, imm`  | B    | `if (rs1 != rs2) PC = PC + {imm,1’b0}`            |
| `blt rs1, rs2, imm`  | B    | `if (rs1 < rs2) PC = PC + {imm,1’b0}` (signed)    |
| `bge rs1, rs2, imm`  | B    | `if (rs1 >= rs2) PC = PC + {imm,1’b0}` (signed)   |
| `bltu rs1, rs2, imm` | B    | `if (rs1 < rs2) PC = PC + {imm,1’b0}` (unsigned)  |
| `bgeu rs1, rs2, imm` | B    | `if (rs1 >= rs2) PC = PC + {imm,1’b0}` (unsigned) |
| `jal rd, imm`        | J    | `rd = PC + 4; PC = PC + {imm,1’b0}`               |
| `jalr rd, rs1, imm`  | I    | `rd = PC + 4; PC = rs1 + imm`                     |
| `lui rd, imm`        | U    | `rd = imm << 12`                                  |
| `auipc rd, imm`      | U    | `rd = PC + (imm << 12)`                           |

Store instructions are limited to `sw` due to the simple memory write-back logic.

The environment instructions(`ecall`, `ebreak`) are not supported in our design due to their complexity.

### IO

We use **MMIO**(Memory Mapping IO) and **polling** to implement IO interaction.

Inputs: 16 dip switches, 4 buttons

Outputs: 16 LEDs, 7-seg tubes

| Device               | Address    |
| -------------------- | ---------- |
| Left 8 LEDs          | 0xFFFF0000 |
| Right 8 LEDs         | 0xFFFF0004 |
| Left 8 DIP Switches  | 0xFFFF0008 |
| Right 8 DIP Switches | 0xFFFF000C |
| Button 0(R11)        | 0xFFFF0010 |
| Button 1(R17)        | 0xFFFF0014 |
| Button 2(R15)        | 0xFFFF0018 |
| Button 3(V1)         | 0xFFFF001C |
| 7-Seg Tubes          | 0xFFFF0020 |

### CPU Interface

```verilog
module CPU(
    input clk_in, rst,
    input [7:0] switch,  // data from little switch
    input [7:0] SWITCH,  // data from big switch
    input button0, button1, button2, button3,  // buttons

    output [7:0] LED,  // data to big LED
    output [7:0] led,  // data to little LED
    output [7:0] com,
    output [7:0] seg_out_left, seg_out_right
);
```

Input: 

​	`clk_in`: On-board 100MHz clock signal
​	`rst`: Active-low reset signal
​	`switch`: Input signal from switches on the right side
​	`SWITCH`: Input signal from switches on the left side
​	`button0`, `button1`, `button2`, `button3`: Input signal from 4 buttons 

Output:

​	`LED`: Control signal of the 8 LEDs on the left side
​	`led`: Control signal of the 8 LEDs on the right side
​	`com`: Digital tube chip select signal
​	`seg_out_left`, `seg_out_right`: Digital tube control signals

## Solution Analysis Explanation

### Floating-Point Operations

**Hardware Solution**: Using **Verilog modules**. The execution time will be **significantly shorter** due to the implementation with combinational logic. However, it will be very difficult to debug because simulation cannot fully cover the scenarios of on-board testing. It also needs a large number of flip-flops, which represents a considerable cost for actual CPU manufacturing.

**Software Solution**: Using **RISC-V code** to simulate floating-point operations using integer operations. The execution time will be longer because it needs a huge amount of code, which means **a lot of CPU cycles**. But it has a low requirement of hardware resources, and debugging has been easier thanks to tools like RARS(RISC-V Assembler and Runtime Simulator).

Based on our analysis, although the hardware implementation of the floating-point adder provides better performance, we chose the **software implementation** due to its simplicity, lower resource usage, and easier debugging process in the current development stage. Above all, if **the format of input data changes**(e.g. from 12-bit to 16-bit or 32-bit), we can adjust the assembly code **without** re-synthesizing the hardware and re-generate the bitstream, which saves a lot of time.

### IO Processing

**Hardware Solution**: **Interrupt**. It can **significantly reduce CPU usage** while waiting for input, which is highly consistent with the actual CPU running scenarios. However, it needs **both interrupt support** from CPU(interrupt controller) and instruction(`ecall`, `ebreak`), which is a complex design, especially for the CPU part.

**Software Solution**: **Polling**. The implementation is **simple**, without hardware supports. The CPU actively reads the memory of I/O devices in a loop. However, it consumes **a large number of CPU cycles**, especially being inefficient when waiting for low-frequency events. Therefore, it is not suitable for systems with high performance requirements.

Considering the overall complexity of system design and the limited scale of our course project, we ultimately adopted **polling** as the I/O handling method. Although it is less efficient than interrupt-driven I/O, polling is significantly easier to implement and debug. Since our project does not involve high-frequency or real-time I/O interactions, the performance of polling is acceptable.

## Instructions for Using the System Board

![IO_Planning](/docs/CS202_ProjectDocument.assets/IO_Planning-1749234760634-2.png)

#### How to Complete Tests

In the initial state, the CPU enters **test case selection mode**, and the 7-seg tube shows **"INPUT"**. At this stage, the user selects the desired test case number using the **right DIP switches**, and confirms the selection by pressing **Button1(R17)**.

After confirmation, the CPU enters **test execution mode**, during which the 7-seg tube shows **"TESTING"**, and the **right-side LEDs** indicate the current test scenario and test case number.

- For testcases **that do not require input data**, the CPU directly output the expected data, and then enters the **test completion state**.
- For testcases **requiring a single input**, the user inputs the data via the **left DIP switches** and confirms by pressing **Button2(R15)**. 
- For testcases **requiring two inputs**, the user inputs the values sequentially using the **left DIP switches**, confirming the **first value** with **Button2(R15)** and the **second** with **Button3(V1)**. 
- For different test case requirements, the CPU may display the output content on the **left LED** or **7-seg tube**. Once the CPU finishes processing and outputting the data, it enters the **test completion state**.

In the **test completion state**, pressing **Button0(R11)** will exit the current test and return the CPU to the **test case selection mode**.

Pressing the **reset button(P15)**, the CPU will return to the **test case selection mode**.

#### Output Data

The output data is 32-bit wide. The **7-seg tube** shows the **hexadecimal form** of the output. The **LEDs** display the **binary form** of the **lower 8 bits** of the output.

## Self Testing Instructions

| Testing Method | Testing Type                           | Testcase Description                                         | Test Result |
| -------------- | -------------------------------------- | ------------------------------------------------------------ | ----------- |
| Simulation     | Unit test - `ALU`                      | Manually generate test numbers for each `ALUOp` .            | Passed      |
| Simulation     | Unit test - `ALUControl`, `Controller` | Generate the corresponding 32-bit instructions using the code from labs or assignments, and observe each signal in the waveform. | Passed      |
| Simulation     | Unit test - `display_assign`           | Manually generate data to cover the display contents, and observe whether the corresponding content is displayed through the waveform. | Passed      |
| Simulation     | Integration test - `CPU`               | Manually write different types of instructions, generate the corresponding .coe files, and observe the CPU operation status through waveform. | Passed      |
| On Board       | Unit test - IO                         | Copy the data from the DIP switch to the LED and 7-seg tube through RISC-V code, observe to test. | Passed      |
| On Board       | Integration test - Test Scenario 1     | Test the CPU functionality and the correctness of the assembly code of Test Scenario 1. | Passed      |
| On Board       | Integration test - Test Scenario 2     | Test the correctness of the assembly code in Test Scenario 2. | Passed      |

#### Conclusion

Although the CPU passed the tests successfully for the manually-generated data. However, during the final defense, it still encountered an issue when handling input provided by the instructor. This highlights the importance of using randomly-generated data for more comprehensive testing.

## Open Source and AI

##### MemOrIO

The `MemOrIO` module was initially challenging to implement, but we were inspired by reference designs from open-source projects shared by senior students.

##### Test Scenarios

The idea for the binary reversal algorithm came from a C-language implementation on CSDN, which we adapted and rewrote in RISC-V for our project.

The algorithm for floating-point processing and computation was inspired by suggestions from ChatGPT. However, during testing, we observed that the AI's approach for extracting the integer part always used floor operation, which led to incorrect results for negative floating-point numbers, for example, -1.5 and -2.6 were converted to -2 and -3 respectively. To solve this problem, we modified the rounding strategy: we apply floor for positive numbers and ceiling for negative numbers to obtain the correct integer part.

## Project Summary

### Problems

During the initial phase of on-board testing, we encountered a problem where the CPU **failed to correctly access I/O devices**. After investigation and discussion, we identified the root cause as **a timing mismatch** between the CPU and peripheral devices. This issue was resolved by **lowering the CPU clock frequency** to match the access timing of I/O components better.

### Summary

- **UART Support**: One major regret of the project is the absence of UART support. Without UART, even a minor code change required us to regenerate the bitstream, which took several minutes each time and significantly slowed down development.
- **Testing**: Unit testing should be completed thoroughly before system integration. Additionally, we recommend using randomly generated test data to ensure full coverage. Manually created test cases often fail to represent edge conditions, which can lead to undetected bugs.
- **Time Management**: The project should be started and completed as early as possible, especially when *the general framework and requirements are already known in advance*. Procrastinating not only increases stress toward the deadline, but also significantly disrupts the scheduling of other course assignments and exam preparation during the final weeks.
- **Teamwork**: Effective team communication and a well-planned division of labor are crucial for project success. Unclear responsibilities and inefficient communication can severely hinder progress and cause unnecessary delays.

## Bonus

### `auipc` Instruction Support

#### Implementation

The implementation was relatively straightforward: we modified `Controller` module to recognize the opcode and generate the corresponding control signals. Additionally, `ALUControl` module was modified to correctly select the operands for `auipc`.

```verilog
// Controller.v
always @(*) begin  // ALUOp
    case (inst[6:0])
        L, S, I_jalr, J, U_lui, U_auipc: ALUOp = 0;
        // Existing code...
    endcase
end

always @(*) begin  // ALUSrc
    case (inst[6:0])
        // Existing code...
        U_auipc: ALUSrc = 4;
    endcase
end

always @(*) begin  // RegWrite, MemWrite, ioWrite
    case (inst[6:0])
        R, I, L, J, I_jalr, U_lui, U_auipc: begin
            RegWrite = 1;
            MemWrite = 0;
            ioWrite = 0;
        end
        // Existing code...
    endcase
end

// ALUControl.v
always @(*) begin  // Operands selection
    case (ALUSrc)
        // Existing code...
        4: begin  // auipc
            op1 = pc;
            op2 = imm32;
        end
        // Existing code...
    endcase
end
```

#### Test

##### Description

To verify the correctness of `auipc`, we designed a testing framework based on ***RARS***. The tests were conducted by executing instructions on the CPU while simultaneously simulating the same test cases in *RARS* for result comparison. The output was displayed in hexadecimal on the 7-seg tubes.

##### Test Scenarios and Cases

 The test cases focus on verifying three instructions: `jal`, `jalr`, and `auipc`.

- After pressing **Button2**, the CPU executes a `jal` test case.
  - If `jal` is executed correctly, `sw t3, 0x00(t0)`will be skipped and the left LED will not light up.

- After pressing **Button3**, the CPU executes a `jalr` test case.
  - If `jalr` is executed correctly, `sw t3, 0x00(t0)`will be skipped and the left LED will not light up.

- Pressing **Button2**, the CPU executes the `auipc` test case.
  - If `auipc` is executed correctly, 7-seg tube will display the hexadecimal value of `pc + 0xABCDE`.


To ensure accurate observation of the effects of each instruction, `addi x0, x0, 0` instructions were inserted between the three instructions.

```assembly
test2_7_jal:
	# waiting for pressing button2...
	addi x0, x0, 0
	jal test2_7_jalr  # jump to test2_7_jalr
	sw t3, 0x00(t0)  # load 0xFF to LEDbig but skipped due to jalr
	addi x0, x0, 0  # NOP but skipped due to jalr
	
test2_7_jalr:
	sw x1, 0x20(t0)  # store x1 to seg tubes
	# waiting for pressing button3...
	la x2, test2_7_skip   # load the address of "sw t3, 0x00(t0)"
	jalr x1, x2, 4  # jump to "sw t3, 0x00(t0)" + 4 = "addi x0, x0, 0"
	
test2_7_skip:
	sw t3, 0x00(t0)  # load 0xFF to LEDbig but skipped due to jalr
	addi x0, x0, 0
	sw x1, 0x20(t0)  # store the result of jalr to seg tubes
	
test2_7_auipc:
	# waiting for pressing button2...
	addi x0, x0, 0
	addi x0, x0, 0
	auipc a0, 0xABCDE  # a0 = 0xABCDE000 + pc
	sw a0, 0x20(t0)  # store the result of auipc to seg tubes
```

![bonus_test_comparison](/docs/CS202_ProjectDocument.assets/bonus_test_comparison.png)

##### Test Results

The outputs from the CPU matches the expected results generated by RARS in all test cases, which confirms that the implementation of `auipc` is correct.

#### Problems

**Timing of Instruction Memory**: The `pc` value in the `IFetch` module is updated on the **falling edge** of the clock. As a result, when other modules read the `pc` for calculation, what they received is the **next instruction**'s `pc` rather than the current one. To resolve this, we introduced a new signal port `pcOld` in the `IFetch` module to hold the **current instruction**'s `pc`, allowing correct computation for `auipc`.

```verilog
always @(negedge clk or negedge rst) begin
    if (!rst) begin  // initialize
        pcOld <= 32'b0;
        pc <= 32'b0;
    end
    else if (branch & ~zero) begin  // branch
        pcOld <= pc;
        if (inst[6:0] != 7'b1100111) begin  // besides jalr, pc += imm32
            pc <= pc + imm32;
        end else begin  // for jalr, pc = rs1Data + imm32
            pc <= rs1Data + imm32;
        end
    end
    else begin  // Sequential execution
        pc <= pc + 4;
        pcOld <= pc;
    end
end
```

#### Summary

**Debug**: It's important to make good use of tools like *RARS* , which greatly simplify validation and help detect some subtle errors. Simulation tools can make the design and debugging process much more efficient.
