cd build
vsim -c +typdelays work.tb_counter -do "log -r /*; run -all; quit -f"