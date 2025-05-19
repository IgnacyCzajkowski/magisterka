import os 

dir = "./params_dir_new"
files_names = os.listdir(dir)

'''

for read_file_name in files_names:
    if ("pv1_" and "email") in read_file_name:
        read_file = open(dir + "/" + read_file_name, "r")
        new_file_name = "pv2" + read_file_name[3:]
        write_file = open(dir + "/" + new_file_name, "w")
        for i, read_line in enumerate(read_file):
            if i == 6:
                out = "1" + read_line[1:]
                write_file.write(out)
            else:
                write_file.write(read_line)    
    
        read_file.close()
        write_file.close()
'''


for read_file_name in files_names:
    if ("email" and "pv1") in read_file_name:
        read_file = open(dir + "/" + read_file_name, "r")
        ba_file_name = read_file_name.replace("email", "ba")
        ba_file = open(dir + "/" + ba_file_name, "w")
        
        er_file_name = read_file_name.replace("email", "er")
        er_file = open(dir + "/" + er_file_name, "w")

        for i, read_line in enumerate(read_file):
            if i == 0:
                er_file.write(read_line.replace("ia-email-univ.mtx", "1000 0.008"))
                ba_file.write(read_line.replace("ia-email-univ.mtx", "1000 5 4"))
            elif i == 1:
                er_file.write(read_line.replace("113", "100"))
                ba_file.write(read_line.replace("113", "100"))
            else:
                er_file.write(read_line)
                ba_file.write(read_line)

        read_file.close()
        er_file.close()
        ba_file.close()      
       