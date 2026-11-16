vlib work

vlog synthesis.v top.v

vsim -voptargs="+acc" +typdelays work.top

log -r /*

run -all

vsim -view vsim.wlf

quit -f