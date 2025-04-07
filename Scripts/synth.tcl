file mkdir ./output

#create project
create_project matcher_proj ./output -part xc7z020clg484-3 -force

#add sources
add_files ./src/matcher.v

#top module
set_property top matcher [current_fileset]

#run synth
launch_runs synth_1 -jobs 4
wait_on_run synth_1

#bitstream creation
write_bitstream -force ./output/matcher.bit
