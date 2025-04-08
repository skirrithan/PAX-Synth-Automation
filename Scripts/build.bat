@echo off
echo Running Vivado synthesis in batch mode...
"C:\Xilinx\Vivado\2024.2\bin\vivado.bat" -mode batch -source ./synth.tcl
pause
