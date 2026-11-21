cd build
vsim -c +typdelays work.tb_lfsr_counter -do "log -r /*; run -all; quit -f"