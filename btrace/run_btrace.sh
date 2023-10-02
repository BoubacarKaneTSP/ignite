#!/bin/bash

# kill all the children of the current process
trap "pkill -KILL -P $$; exit 255" SIGINT SIGTERM
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

nbTest=""
clients="1 2 4 8 16 32 48"
list_stat="OVERALL-RunTime OVERALL-Throughput"
hosts="127.0.0.1"
workload="workloada"
operationcount=1000000
recordcount=1000000
output_file_load="outputload.txt"
output_file_run="outputrun.txt"

nb_client="48"
cd $YCSB_HOME

python2 $YCSB_HOME/bin/ycsb load ignite -p hosts=$hosts -s -P $YCSB_HOME/workloads/$workload -threads $nb_client -p operationcount=$operationcount -p recordcount=$recordcount > $IGNITE_HOME/$output_file_load
python2 $YCSB_HOME/bin/ycsb run ignite -p hosts=$hosts -s -P $YCSB_HOME/workloads/$workload -threads $nb_client -p operationcount=$operationcount -p recordcount=$recordcount > $IGNITE_HOME/$output_file_run &

sleep 5
ycsb_pid=$!

sleep 5

val=$(ps -ef | grep java | tail -n 3 | head -n 1 | grep -o -E '\b\w+\b' | sed -n '2p')

echo "==========================================================> $val"

cd $IGNITE_HOME/btrace
pwd
ls
btrace -o outputBtrace.txt $val Trace.java

wait
cd $IGNITE_HOME/btrace
