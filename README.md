# PAX-Synth-Automation
This proof-of-concept project demonstrates a basic automated FPGA synthesis flow using Xilinx Vivado.

## Structure

- `src/matcher.v`: Example Verilog module (comparator)
- `scripts/synth.tcl`: Vivado synthesis script (runs in batch mode)
- `output/`: Folder where `.bit` and reports are generated
- `Makefile`: For running synthesis via `make build`
- `build.bat`: Alternative Windows-friendly build script

## Usage

### Git Bash or WSL

```bash
make build
