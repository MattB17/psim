BASE_DIR=/home/faridzandi/git/psim
BUILD_PATH=$BASE_DIR/build
RUN_PATH=$BASE_DIR/run
PSIM_EXE=$BUILD_PATH/psim
INPUT_PATH=$BASE_DIR/input/128search-dpstart-2
ARGS="$@"
USE_GDB=0

cd $BUILD_PATH
make -j 48
if [ $? -ne 0 ]; then
    echo "Error: Make command failed. Exiting."
    exit 1
fi


cd $RUN_PATH
cmd="$PSIM_EXE --protocol-file-dir=$INPUT_PATH \
               --protocol-file-name=candle128-simtime.txt \
               --step-size=10 \
               --link-bandwidth=100 \
               --initial-rate=100 \
               --min-rate=10 \
               --ft-core-count=4 \
               --ft-agg-per-pod=4 \
               --console-log-level=4 \
               --ft-server-tor-link-capacity-mult=1 \
               --ft-tor-agg-link-capacity-mult=1 \
               --ft-agg-core-link-capacity-mult=1 \
               --priority-allocator=priorityqueue \
               --core-selection-mechanism=futureload \
               --shuffle-device-map
               --rep-count=20 \
               $ARGS"


if [ $USE_GDB -eq 1 ]; then
    cmd="gdb --args $cmd"
fi

echo $cmd
eval $cmd

