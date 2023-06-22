import sys
import os


def calculate_bounds(values_func):
    # Calcul de la moyenne
    mean_func = sum(values_func) / len(values_func)

    # Calcul de l'écart maximal entre la moyenne et les valeurs
    max_deviation = max(abs(value - mean_func) for value in values_func)

    # Calcul de la borne supérieure et inférieure
    upper_bound_func = mean_func + max_deviation
    lower_bound_func = mean_func - max_deviation

    return mean_func, upper_bound_func, lower_bound_func


YCSB_file_name = sys.argv[1]
flag_avg = sys.argv[2]
load_run_flag = sys.argv[3]
nb_client = sys.argv[4]
list_args = sys.argv[5:len(sys.argv)]


if flag_avg == "True":

    list_nb_client = nb_client.split(" ")

    for nb in list_nb_client:

        for arg in list_args:
            arg0 = arg.split("-")[0]
            arg1 = arg.split("-")[1]
            file_name = "YCSB_"+load_run_flag+"_"+arg0+"_"+arg1+"_"+nb+"_clients.txt"
            #file_name = "YCSB_"+load_run_flag+"_"+arg0+"_"+arg1+"_"+nb+"_clients_noLongAdder.txt"
            file_name_avg = "YCSB_"+load_run_flag+"_"+arg0+"_"+arg1+".txt"
            #file_name_avg = "YCSB_"+load_run_flag+"_"+arg0+"_"+arg1+"_noLongAdder.txt"

            file = open(file_name, "r")

            if nb == "1":
                file_avg = open(file_name_avg, "w")
            else:
                file_avg = open(file_name_avg, "a")

            values = []

            for line in file.readlines():
                val = float(line.split(" ")[2])
                values.append(val)

            mean, upper_bound, lower_bound = calculate_bounds(values)

            file_avg.write(nb + " " + str(mean) + " " + str(upper_bound)+ " " + str(lower_bound) + "\n")

            file.close()
            file_avg.close()

            os.remove(file_name)
else:
    
    file_read = open(YCSB_file_name, "r")

    for line in file_read.readlines():
        
        for arg in list_args:

            arg0 = arg.split("-")[0]
            arg1 = arg.split("-")[1]
            file_name = "YCSB_"+load_run_flag+"_"+arg0+"_"+arg1+"_"+nb_client+"_clients.txt"
           # file_name = "YCSB_"+load_run_flag+"_"+arg0+"_"+arg1+"_"+nb_client+"_clients_noLongAdder.txt"

            if arg0 in line and arg1 in line:

                split_line = line.split(",")
                
                file_write = open(file_name,"a")
                
                #print(nb_client+" "+split_line[len(split_line) - 1])
                file_write.write(nb_client+" "+split_line[len(split_line) - 1])

                file_write.close()
                
    file_read.close()

