#!/bin/bash

# kill all the children of the current process
trap "pkill -KILL -P $$; exit 255" SIGINT SIGTERM
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

<<<<<<< HEAD
nbTest=""
clients="1 2 4 8 16 32 48"
list_stat="OVERALL-RunTime OVERALL-Throughput"
hosts="127.0.0.1"
workload="workloada"
operationcount=10000
recordcount=10000
=======
nbTest=5
clients="1 2 4 8 16 32 48 96"
list_stat="OVERALL-RunTime OVERALL-Throughput"
hosts="127.0.0.1"
workload="workloada"
operationcount=1000000
recordcount=1000000
>>>>>>> test
output_file_load="outputload.txt"
output_file_run="outputrun.txt"

cd $YCSB_HOME

<<<<<<< HEAD
for test in {1. .3}
do
    for nb_client in 1 2 4 8 16 32 48
    do
        # $IGNITE_HOME/bin/**ignite.sh** ignite.xml &
        # ignite_pid = $!

        # echo "$YCSB_HOME/bin/ycsb load ignite -p hosts=$hosts -s -P $YCSB_HOME/workloads/$workload -threads $nb_client -p operationcount=$operationcount -p recordcount=$recordcount > $IGNITE_HOME/$output_file_load"
        $YCSB_HOME/bin/ycsb load ignite -p hosts=$hosts -s -P $YCSB_HOME/workloads/$workload -threads $nb_client -p operationcount=$operationcount -p recordcount=$recordcount > $IGNITE_HOME/$output_file_load
        python3 $IGNITE_HOME/btrace/analyse_YCSB.py $IGNITE_HOME/$output_file_load False load $nb_client $list_stat

        $YCSB_HOME/bin/ycsb run ignite -p hosts=$hosts -s -P workloads/$workload -threads $nb_client -p operationcount=$operationcount -p recordcount=$recordcount > $IGNITE_HOME/$output_file_run
        python3 $IGNITE_HOME/btrace/analyse_YCSB.py $IGNITE_HOME/$output_file_run False run $nb_client $list_stat
    done
done



# Make sure that the nb of client match those computed
python3 $IGNITE_HOME/btrace/analyse_YCSB.py $IGNITE_HOME/$output_file_load True load $clients $list_stat
python3 $IGNITE_HOME/btrace/analyse_YCSB.py $IGNITE_HOME/$output_file_run True run $clients $list_stat
=======

for (( c=1; c<=nbTest; c++ ))
do
  for nb_client in 1 2 4 8 16 32 48 96
  do
    # echo "$YCSB_HOME/bin/ycsb load ignite -p hosts=$hosts -s -P $YCSB_HOME/workloads/$workload -threads $nb_client -p operationcount=$operationcount -p recordcount=$recordcount > $IGNITE_HOME/$output_file_load"
    python2 $YCSB_HOME/bin/ycsb load ignite -p hosts=$hosts -s -P $YCSB_HOME/workloads/$workload -threads $nb_client -p operationcount=$operationcount -p recordcount=$recordcount > $IGNITE_HOME/$output_file_load
    python3 $IGNITE_HOME/btrace/analyse_YCSB.py $IGNITE_HOME/$output_file_load False load $nb_client $list_stat

    python2 $YCSB_HOME/bin/ycsb run ignite -p hosts=$hosts -s -P $YCSB_HOME/workloads/$workload -threads $nb_client -p operationcount=$operationcount -p recordcount=$recordcount > $IGNITE_HOME/$output_file_run
    python3 $IGNITE_HOME/btrace/analyse_YCSB.py $IGNITE_HOME/$output_file_run False run $nb_client $list_stat
  done
done


# Make sure that the nb of client match those computed
python3 $IGNITE_HOME/btrace/analyse_YCSB.py $IGNITE_HOME/$output_file_load True load "$clients" $list_stat
python3 $IGNITE_HOME/btrace/analyse_YCSB.py $IGNITE_HOME/$output_file_run True run "$clients" $list_stat
>>>>>>> test

cd $IGNITE_HOME/btrace
