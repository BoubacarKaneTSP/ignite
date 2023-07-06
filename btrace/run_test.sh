#!/bin/bash

# kill all the children of the current process
trap "pkill -KILL -P $$; exit 255" SIGINT SIGTERM
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

nbTest=20
#clients="1 10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180 190 200"
clients="90 110 130 150 170 190 200"
#clients="1 2 4 8 16 32 48 96"
list_stat="OVERALL-RunTime OVERALL-Throughput"
hosts="127.0.0.1"
workload="workloada"
operationcount=10000000
recordcount=1000000
output_file_load="outputload.txt"
output_file_run="outputrun.txt"

flag_append="w"

cd $YCSB_HOME || exit

rm YCSB_*

for (( c=1; c<=nbTest; c++ ))
do
  #for nb_client in 1 10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180 190 200
  for nb_client in 90 110 130 150 170 190 200
  #for nb_client in 1 2 4 8 16 32 48 96
  do


    echo " "
    echo " "
    echo "====> test num [$c] with [$nb_client] client(s)"
    echo " "
    echo " "
    python2 $YCSB_HOME/bin/ycsb load ignite -p hosts=$hosts -s -P $YCSB_HOME/workloads/$workload -threads $nb_client -p operationcount=$operationcount -p recordcount=$recordcount > $IGNITE_HOME/$output_file_load
    python3 $IGNITE_HOME/btrace/analyse_YCSB.py $IGNITE_HOME/$output_file_load False $flag_append load $nb_client $list_stat

    python2 $YCSB_HOME/bin/ycsb run ignite -p hosts=$hosts -s -P $YCSB_HOME/workloads/$workload -threads $nb_client -p operationcount=$operationcount -p recordcount=$recordcount > $IGNITE_HOME/$output_file_run
    python3 $IGNITE_HOME/btrace/analyse_YCSB.py $IGNITE_HOME/$output_file_run False $flag_append run $nb_client $list_stat
    
    if [ $flag_append = "w" ]; then
        flag_append="a"
    fi

  done
done


# Make sure that the nb of client match those computed
python3 $IGNITE_HOME/btrace/analyse_YCSB.py $IGNITE_HOME/$output_file_load True $flag_append load "$clients" $list_stat
python3 $IGNITE_HOME/btrace/analyse_YCSB.py $IGNITE_HOME/$output_file_run True $flag_append run "$clients" $list_stat

cd $IGNITE_HOME/btrace
