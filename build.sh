# rm -rf build
# mkdir build
# cd build
# vlib work
# vlog +acc=rn +incdir+../src +incdir+../tb ../src/*.v ../tb/*.v

rm -rf build
mkdir build
vlib build/work
vlog -work build/work +acc=rn +incdir+src +incdir+tb src/*.v tb/*.v
