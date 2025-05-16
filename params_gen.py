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
    if "email" in read_file_name:
        read_file = open(dir + "/" + read_file_name, "r")
        infectious_file_name = read_file_name.replace("email", "infectious")
        infectious_file = open(dir + "/" + infectious_file_name, "w")
        
        ucirving_file_name = read_file_name.replace("email", "ucirving")
        ucirving_file = open(dir + "/" + ucirving_file_name, "w")

        for i, read_line in enumerate(read_file):
            if i == 0:
                infectious_file.write(read_line.replace("ia-email-univ.mtx", "infectious.txt"))
                ucirving_file.write(read_line.replace("ia-email-univ.mtx", "UCIrving.net"))
            elif i == 1:
                infectious_file.write(read_line.replace("113", "41"))
                ucirving_file.write(read_line.replace("113", "102"))
            else:
                infectious_file.write(read_line)
                ucirving_file.write(read_line)

        read_file.close()
        infectious_file.close()
        ucirving_file.close()      
       