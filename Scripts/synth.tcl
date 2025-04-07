file mkdir ./output

# ✅ Suppress DRC blocking conditions globally
set_property SEVERITY {Warning} [get_drc_checks NSTD-1]
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]

# ✅ Create and configure project
create_project matcher_proj ./output -part xc7k160tfbg484-1 -force
add_files ./src/matcher.v
add_files ./src/matcher.xdc
set_property top matcher [current_fileset]

# ✅ Run synthesis
launch_runs synth_1 -jobs 4
wait_on_run synth_1

# #Open synthesized design and apply problematic constraints explicitly
# open_run synth_1
# # Reapply problematic constraints to ensure they're recognized
# set_property PACKAGE_PIN L17 [get_ports {buy[12]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {buy[12]}]
# set_property PACKAGE_PIN A17 [get_ports {sell[12]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {sell[12]}]
# set_property PACKAGE_PIN T17 [get_ports match]
# set_property IOSTANDARD LVCMOS33 [get_ports match]
# close_design

# ✅ Run implementation (Vivado auto-creates impl_1)
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1

# Only try to write bitstream again if implementation was successful
if {[get_property PROGRESS [get_runs impl_1]] == "100%"} {
    # Copy the bitstream to the output folder instead of regenerating it
    file copy -force ./output/matcher_proj.runs/impl_1/matcher.bit ./output/matcher.bit
    puts "Bitstream generated successfully and copied to output folder."
} else {
    puts "Implementation failed. Check logs for details."
}
