#!/bin/bash
set -ex
export OPENLANE_IMAGE_NAME=efabless/openlane
export OPENLANE_ROOT=/home/emil/pulls/OpenLane
export PDK_ROOT=/home/emil/pulls/OpenLane/pdks
export PDK=sky130B

# pushd $HOME/pulls/caravel_user_project
# make setup
# popd

DEPTH=8
for WIDTH in {24..32..1}
do
	python designs/aig_bench/src/aig_bench.py -d $DEPTH -w $WIDTH generate designs/aig_bench/src/aig_bench.v
	docker run --rm \
		-v $OPENLANE_ROOT:/openlane \
		-v $PDK_ROOT:$PDK_ROOT \
		-v $(pwd):/work \
		-e PDK_ROOT=$PDK_ROOT \
		-e PDK=$PDK \
		-u $(id -u $USER):$(id -g $USER) \
		$OPENLANE_IMAGE_NAME \
		/bin/bash -c "./flow.tcl -ignore_mismatches -verbose 2 -overwrite -design aig_bench -tag BENCH_$WIDTH\_$DEPTH"
done