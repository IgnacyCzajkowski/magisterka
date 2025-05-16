import os 

dir = "./params_dir_new"
files_names = os.listdir(dir)

for read_file_name in files_names:
    if "bm1" in read_file_name:
        read_file = open(dir + "/" + read_file_name, "r")
        for beta_main in ["04"]:
            wrtie_file_name = read_file_name.replace("bm1", "bm" + beta_main)
            write_file = open(dir + "/" + wrtie_file_name, "w")
            for i, read_line in enumerate(read_file):
                if i == 3:
                    #write_file.write(read_line.replace("1", beta_main[0] + "." + beta_main[1]))
                    new_line = beta_main[0] + "." + beta_main[1] + read_line[1:]
                    print(new_line)
                    write_file.write(new_line)
                else:
                    write_file.write(read_line)
            write_file.close()
        read_file.close()                
