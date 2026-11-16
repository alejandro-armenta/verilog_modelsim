rm -rf build
mkdir build
vlib build/work
vlog -work build/work +acc=rn +incdir+src +incdir+tb src/*.v tb/*.v

