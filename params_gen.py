import os 

dir = "./params_dir"
files_names = os.listdir(dir)

'''

for read_file_name in files_names:
    if ("pv1_ifn_" and "infectious") in read_file_name:
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
    if "infectious" in read_file_name:
        read_file = open(dir + "/" + read_file_name, "r")
        email_file_name = read_file_name.replace("infectious", "email")
        email_file = open(dir + "/" + email_file_name, "w")
        
        ucirving_file_name = read_file_name.replace("infectious", "ucirving")
        ucirving_file = open(dir + "/" + ucirving_file_name, "w")

        for i, read_line in enumerate(read_file):
            if i == 0:
                email_file.write(read_line.replace("infectious.txt", "ia-email-univ.mtx"))
                ucirving_file.write(read_line.replace("infectious.txt", "UCIrving.net"))
            elif i == 1:
                email_file.write(read_line.replace("41", "113"))
                ucirving_file.write(read_line.replace("41", "102"))
            else:
                email_file.write(read_line)
                ucirving_file.write(read_line)

        read_file.close()
        email_file.close()
        ucirving_file.close()      