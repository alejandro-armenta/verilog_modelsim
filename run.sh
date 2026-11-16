cd build

vsim -c +typdelays work.top -do "log -r /*; run -all; quit -f"
