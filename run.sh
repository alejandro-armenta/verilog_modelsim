rm -rf work vsim.wlf
vlib work && vlog +acc=rn synthesis.v top.v && vsim -c +typdelays work.top -do "log -r /*; run -all; quit -f"
