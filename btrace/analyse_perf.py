import sys
import os

perf_file_name = sys.argv[1]
avg_flag = sys.argv[2]
object_name = sys.argv[3]
nb_thread = sys.argv[4]

list_event = ["cache-references", "cache-misses", "branch-misses", "branches", "cycles", "instructions", "l1d_pend_miss.pending_cycles_any", "l2_rqsts.all_demand_miss", "cycle_activity.stalls_total"]
# list_nb_thread = [1, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200]
list_nb_thread = [90, 110, 130, 150, 170, 190, 200]
# list_nb_thread = [1]
if avg_flag == "true":

    for event in list_event:
        file_avg = open("perf_"+event+"_"+object_name+".txt", "w")

        for i in list_nb_thread:
            file = open("perf_"+event+"_"+object_name+"_" + str(i)+"_thread.txt", "r")
            nb_line = 0
            sum = 0

            for line in file.readlines():
                sum += float(line)
                nb_line += 1

            file_avg.write(str(i) + " " + str(sum/nb_line) +"\n")
            file.close()
            os.remove("perf_"+event+"_"+object_name+"_" + str(i)+"_thread.txt")
        file_avg.close()

    ratio_cache_misses_avg = open("perf_ratio_cache_misses_"+object_name+".txt", "w")
    ratio_branch_misses_avg = open("perf_ratio_branch_misses_"+object_name+".txt", "w")
    instruction_per_cycle_avg = open("perf_instruction_per_cycle_"+object_name+".txt", "w")

    for i in list_nb_thread:
        ratio_cache_misses = open("perf_ratio_cache_misses_"+object_name+"_" + str(i) +"_thread.txt", "r")
        ratio_branch_misses = open("perf_ratio_branch_misses_"+object_name+"_" + str(i) +"_thread.txt", "r")
        instruction_per_cycle = open("perf_instruction_per_cycle_"+object_name+"_" + str(i) +"_thread.txt", "r")

        sum_cache_misses = 0
        sum_branch_misses = 0
        sum_instruction_per_cycles = 0

        nb_line_cache_misses = 0
        nb_line_branch_misses = 0
        nb_line_instruction_per_cycles = 0

        for line in ratio_cache_misses.readlines():
            sum_cache_misses += float(line)
            nb_line_cache_misses += 1

        for line in ratio_branch_misses.readlines():
            sum_branch_misses += float(line)
            nb_line_branch_misses += 1

        for line in instruction_per_cycle.readlines():
            sum_instruction_per_cycles += float(line)
            nb_line_instruction_per_cycles += 1

        ratio_cache_misses_avg.write(str(i) + " " + str(sum_cache_misses/nb_line_cache_misses) + "\n")
        ratio_branch_misses_avg.write(str(i) + " " + str(sum_branch_misses/nb_line_branch_misses) + "\n")
        instruction_per_cycle_avg.write(str(i) + " " + str(sum_instruction_per_cycles/nb_line_instruction_per_cycles) +"\n")

        ratio_cache_misses.close()
        ratio_branch_misses.close()
        instruction_per_cycle.close()

        os.remove("perf_ratio_cache_misses_"+object_name+"_" + str(i) +"_thread.txt")
        os.remove("perf_ratio_branch_misses_"+object_name+"_" + str(i) +"_thread.txt")
        os.remove("perf_instruction_per_cycle_"+object_name+"_" + str(i) +"_thread.txt")

    ratio_cache_misses_avg.close()
    ratio_branch_misses_avg.close()
    instruction_per_cycle_avg.close()

else:

    perf_log_raw = open(perf_file_name,"r")

    dico_stat_event = dict()
    dico_file_event = dict()

    append = "a"

    for event in list_event:
        dico_stat_event[event] = None
        dico_file_event[event] = open("perf_"+event+"_"+object_name+ "_" + nb_thread+"_thread.txt", append)

    ratio_cache_misses = open("perf_ratio_cache_misses_"+object_name+ "_" + nb_thread+"_thread.txt", append)
    ratio_branch_misses = open("perf_ratio_branch_misses_"+object_name+ "_" + nb_thread+"_thread.txt", append)
    instruction_per_cycle = open("perf_instruction_per_cycle_"+object_name+ "_" + nb_thread+"_thread.txt", append)

    for line in perf_log_raw.readlines():

        line = line.strip()

        # print(line)
        # print("-------------------")
        for event in list_event:
            if event in line:
                if dico_stat_event[event] is None:
                    val = line.partition(event)[0].strip()
                    dico_stat_event[event] = val



    for k,v in dico_stat_event.items():

        dico_file_event[k].write(v + "\n")
        dico_file_event[k].close()
        # print("key : " + k +",","value : " + v)

    ratio_cache_misses.write(str(int(dico_stat_event["cache-misses"]) / int(dico_stat_event["cache-references"]) * 100) + "\n")
    ratio_branch_misses.write(str(int(dico_stat_event["branch-misses"]) / int(dico_stat_event["branches"]) * 100) + "\n")
    instruction_per_cycle.write(str(int(dico_stat_event["instructions"]) / int(dico_stat_event["cycles"])) + "\n")

    ratio_cache_misses.close()
    ratio_branch_misses.close()
    instruction_per_cycle.close()
    perf_log_raw.close()
