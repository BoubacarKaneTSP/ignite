#!/bin/bash

# kill all the children of the current process
trap "pkill -KILL -P $$; exit 255" SIGINT SIGTERM
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

nbTest=""
clients="1 2 4 8"
list_stat="OVERALL-RunTime OVERALL-Throughput"

for nb_client in 1 2 4 8
do
    python3 analyse_YCSB.py output-ignite.txt False $nb_client $list_stat
done
