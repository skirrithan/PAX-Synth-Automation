# PAX Markets FPGA Proof of Concept - Automated Synthesis & Bitstream Generation

This project demonstrates a **hardware-automated synthesis flow** targeting Xilinx FPGAs, with a focus on **event-driven matching logic**, designed as a proof-of-concept (PoC) for **PAX Markets**. It showcases the feasibility of using FPGAs for high-performance financial applications and prepares the ground for **AWS EC2 F1 deployment**.

---

## Project Overview

- ✅ Hardware matcher module in Verilog (`matcher.v`)
- ✅ Full synthesis and bitstream automation using a Windows `.bat` script
- ✅ Complete constraint file (`matcher.xdc`) for `xc7k160tfbg484-1` target FPGA
- ✅ Project structure ready for extension toward AWS EC2 F1 packaging

---

## Environment Setup

### Requirements

- [Xilinx Vivado 2024.2](https://www.xilinx.com/products/design-tools/vivado.html) (with proper device support)
- Windows Command Prompt or Git Bash
- Git (for version control)
- (Optional) AWS CLI, Vitis, or SDAccel (for future EC2 packaging)

---

## File Structure

```
PAX-Synth-Automation/
├── src/
│   ├── matcher.v           # Core Verilog design (simple price matcher)
│   └── matcher.xdc         # I/O constraints for xc7k160tfbg484-1
├── scripts/
│   └── synth.bat           # Batch file automating Vivado synthesis + bitstream generation
├── output/
│   └── matcher.bit         # Generated bitstream file
├── README.md               # You're reading this
```

---

## How to Run the Project

1. Make sure `matcher.v` and `matcher.xdc` are in `src/`
2. From the root directory, run:

```bash
scripts\synth.bat
```

This will:
- Launch Vivado in batch mode
- Create a new project with the correct part
- Add source files and constraints
- Run synthesis and implementation
- Generate `matcher.bit` in the `output/` folder

---

## Bitstream Output

Once the script completes successfully, the generated bitstream file will be located at:

```
output/matcher.bit
```

This `.bit` file can be used for FPGA programming or be wrapped for cloud deployment.

---

## Understanding the Matcher Logic

```verilog
module matcher(
    input [15:0] buy,
    input [15:0] sell,
    output match
);
    assign match = (buy >= sell);
endmodule
```

A simple price comparator: emits `1` on `match` if buy >= sell. In practice, this can be extended to support pipelining, timestamping, and order book logic.

---

## Forward Thinking: AWS EC2 F1 Integration

### Future Deployment Steps

This project is designed to be easily migrated to an AWS EC2 FPGA setup using Xilinx’s AWS toolchain:

1. **Generate a partial reconfigurable design** (DCP format)
2. **Wrap design into AWS shell** using AWS’s `sdk` or `vitis`
3. **Use AWS FPGA Management Tools**:
   ```bash
   ./aws_build_dcp_from_tcl.sh
   ./aws_build_bitstream.sh
   ./aws_create_sdaccel_image.sh
   ```
4. **Upload to EC2 F1** via AWS CLI and test with real workloads

---

## Relevance to PAX Markets

This PoC reflects:
- Deep understanding of low-latency hardware workflows
- Build system automation for reliable synthesis/deployment
- Awareness of AWS-compatible FPGA development pipelines
- Realistic design that can evolve into a matching engine or pre-trade risk logic

---

## Final Notes

While simple, this project emphasizes **workflow reproducibility**, **hardware logic clarity**, and **cloud-readiness**. These traits are critical for deploying FPGA-based accelerators in fast-moving production environments like those at **PAX Markets**.

---
