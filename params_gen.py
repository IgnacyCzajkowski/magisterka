import os 

dir = "./params_dir"
files_names = os.listdir(dir)

for read_file_name in files_names:
    if "pv1_ifn_bn" in read_file_name:
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